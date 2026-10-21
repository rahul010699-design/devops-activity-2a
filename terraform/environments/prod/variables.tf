variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Prod GCP region"
  type        = string
}

variable "network_name" {
  description = "Prod VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Prod subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Prod subnet CIDR"
  type        = string
}

variable "pods_cidr" {
  description = "Prod GKE pods CIDR"
  type        = string
}

variable "services_cidr" {
  description = "Prod GKE services CIDR"
  type        = string
}

variable "private_services_cidr" {
  description = "Prod Cloud SQL private services CIDR"
  type        = string
}

variable "cluster_name" {
  description = "Prod GKE Autopilot cluster name"
  type        = string
}

variable "database_instance_name" {
  description = "Prod Cloud SQL instance name"
  type        = string
}

variable "database_name" {
  description = "Prod PostgreSQL database name"
  type        = string
}

variable "database_user" {
  description = "Prod PostgreSQL username"
  type        = string
}

variable "database_tier" {
  description = "Prod Cloud SQL machine tier"
  type        = string
}

variable "database_disk_size" {
  description = "Prod Cloud SQL disk size in GB"
  type        = number
}
