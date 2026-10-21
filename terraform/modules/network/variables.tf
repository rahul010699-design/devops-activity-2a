variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the VPC subnet"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary CIDR range for the subnet"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary CIDR range for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary CIDR range for GKE services"
  type        = string
}

variable "private_services_cidr" {
  description = "CIDR range reserved for Cloud SQL private services access"
  type        = string
}
