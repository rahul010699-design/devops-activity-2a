output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "ID of the VPC subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Name of the VPC subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "private_services_range_name" {
  description = "Name of the reserved private services IP range"
  value       = google_compute_global_address.private_services.name
}
