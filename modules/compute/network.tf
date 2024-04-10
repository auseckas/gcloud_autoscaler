

resource "google_compute_subnetwork" "public_subnet" {
  name          = format("%s", "${var.company}-${var.region}-pub-net")
  ip_cidr_range = var.public_subnet
  network       = var.network_self_link
  region        = var.region
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = format("%s", "${var.company}-${var.region}-pri-net")
  ip_cidr_range = var.private_subnet
  network       = var.network_self_link
  region        = var.region
}

resource "google_compute_address" "public_ip" {
  name = "${var.region}-public-ip"
}

resource "google_compute_address" "private_ip" {
  name         = "${var.region}-private-ip"
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.private_subnet.name
}
