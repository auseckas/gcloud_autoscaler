output "lb_ips" {
  value = {
    "${var.region}" = google_compute_address.public_ip.address
  }
}
