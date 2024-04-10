resource "google_compute_forwarding_rule" "forwarding_rule_public" {
  name       = "${var.region}-forwarding-rule-public"
  target     = google_compute_target_pool.target_pool.id
  port_range = "80"
  region     = var.region

  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_address.public_ip.address
}

resource "google_compute_firewall" "nginx_pubic_access" {
  name               = "${var.region}-fw-public"
  network            = var.network_self_link
  destination_ranges = ["${google_compute_address.public_ip.address}/32"]
  allow {
    protocol = "tcp"
    ports    = [80]
  }
  source_ranges = ["0.0.0.0/0"]
}
