variable "cluster_name" {
  description = "Name of the GKE Autopilot cluster"
  type        = string
}

variable "region" {
  description = "GCP region for the GKE cluster"
  type        = string
}

variable "network_id" {
  description = "VPC network ID"
  type        = string
}

variable "subnet_id" {
  description = "VPC subnet ID"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary range name for GKE pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary range name for GKE services"
  type        = string
}
