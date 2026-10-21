variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "database_user" {
  description = "PostgreSQL database user"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "tier" {
  description = "Cloud SQL machine tier"
  type        = string
}

variable "disk_size" {
  description = "Cloud SQL disk size in GB"
  type        = number
}

variable "network_id" {
  description = "VPC network ID for private IP"
  type        = string
}

variable "private_services_range_name" {
  description = "Private Service Access reserved range name"
  type        = string
}

variable "database_password" {
  description = "Database password supplied from Secret Manager"
  type        = string
  sensitive   = true
}
