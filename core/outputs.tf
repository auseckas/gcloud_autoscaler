output "loadbalancer_ips" {
  description = "The ip address for LB"
  value = {
  for r, ip in module.compute : r => ip }
}
