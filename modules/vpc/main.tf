locals {
  private_subnets_string = join(",", [for r in var.compute_regions : r.private_subnet])
  private_subnet_list    = split(",", local.private_subnets_string)
  public_subnets_string  = join(",", [for r in var.compute_regions : r.public_subnet])
  public_subnet_list     = split(",", local.public_subnets_string)
}

resource "google_compute_network" "vpc" {
  name                    = format("%s", "${var.company}-vpc")
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.company}-fw-allow-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = concat(local.private_subnet_list, local.public_subnet_list)
}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.company}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-iap" {
  name    = "${var.company}-fw-allow-iap"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = ["35.235.240.0/20"]
}

