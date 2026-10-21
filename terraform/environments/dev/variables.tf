variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "network_name" {
  description = "Dev VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Dev subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Dev subnet CIDR"
  type        = string
}

variable "pods_cidr" {
  description = "Dev GKE pods CIDR"
  type        = string
}

variable "services_cidr" {
  description = "Dev GKE services CIDR"
  type        = string
}

variable "private_services_cidr" {
  description = "Dev Cloud SQL private services CIDR"
  type        = string
}

variable "cluster_name" {
  description = "Dev GKE Autopilot cluster name"
  type        = string
}

variable "database_instance_name" {
  description = "Dev Cloud SQL instance name"
  type        = string
}

variable "database_name" {
  description = "Dev PostgreSQL database name"
  type        = string
}

variable "database_user" {
  description = "Dev PostgreSQL username"
  type        = string
}

variable "database_tier" {
  description = "Dev Cloud SQL machine tier"
  type        = string
}

variable "database_disk_size" {
  description = "Dev Cloud SQL disk size in GB"
  type        = number
}
