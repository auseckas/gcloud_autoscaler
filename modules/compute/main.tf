resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "google_compute_image" "ubuntu_2204" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2204-lts"
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "${var.region}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.manager.id

  autoscaling_policy {
    max_replicas    = var.max_workers
    min_replicas    = var.num_workers
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_instance_template" "instance" {
  name         = "${var.region}-vm-template"
  machine_type = var.machine_type
  tags         = var.tags

  metadata = {
    ssh-keys       = "${var.ssh_user}:${tls_private_key.ssh.public_key_openssh}"
    startup-script = <<SCRIPT
        sudo apt update -y &&
        sudo apt install -y nginx
        export HOSTNAME=$(hostname | tr -d '\n')
        echo "Welcome to $HOSTNAME" > /var/www/html/index.html
        service nginx start
        SCRIPT
  }

  disk {
    source_image = data.google_compute_image.ubuntu_2204.id
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.name
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "target_pool" {
  name = "${var.region}-target-pool"
}

resource "google_compute_instance_group_manager" "manager" {
  name = "${var.region}-manager"
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.instance.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.target_pool.id]
  base_instance_name = "${var.region}-compute"
}

