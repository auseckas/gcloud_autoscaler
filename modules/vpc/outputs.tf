
output "vpc" {
  description = "VPC"
  value       = google_compute_network.vpc.self_link
}
