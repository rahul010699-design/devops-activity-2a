output "cluster_name" {
  description = "Name of the GKE Autopilot cluster"
  value       = google_container_cluster.autopilot.name
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE Autopilot cluster"
  value       = google_container_cluster.autopilot.endpoint
}

output "cluster_location" {
  description = "Location of the GKE Autopilot cluster"
  value       = google_container_cluster.autopilot.location
}
