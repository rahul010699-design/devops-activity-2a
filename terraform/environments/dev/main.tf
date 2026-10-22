terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "../../modules/network"

  network_name          = var.network_name
  subnet_name           = var.subnet_name
  region                = var.region
  subnet_cidr           = var.subnet_cidr
  pods_cidr             = var.pods_cidr
  services_cidr         = var.services_cidr
  private_services_cidr = var.private_services_cidr
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.network.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [module.network.private_services_range_name]
  deletion_policy         = "REMOVE_PEERING"
}

module "gke" {
  source = "../../modules/gke"

  cluster_name        = var.cluster_name
  region              = var.region
  network_id          = module.network.network_id
  subnet_id           = module.network.subnet_id
  pods_range_name     = "pods"
  services_range_name = "services"
}

module "cloudsql" {
  source = "../../modules/cloudsql"

  instance_name               = var.database_instance_name
  database_name               = var.database_name
  database_user               = var.database_user
  region                      = var.region
  tier                        = var.database_tier
  disk_size                   = var.database_disk_size
  network_id                  = module.network.network_id
  private_services_range_name = module.network.private_services_range_name
  database_password           = random_password.database.result

  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_secret_manager_secret_version.database_password
  ]
}

output "vpc_name" {
  description = "Dev VPC network name"
  value       = module.network.network_name
}

output "subnet_name" {
  description = "Dev subnet name"
  value       = module.network.subnet_name
}

output "gke_cluster_name" {
  description = "Dev GKE Autopilot cluster name"
  value       = module.gke.cluster_name
}

output "gke_cluster_location" {
  description = "Dev GKE cluster location"
  value       = module.gke.cluster_location
}

output "cloudsql_instance_name" {
  description = "Dev Cloud SQL instance name"
  value       = module.cloudsql.instance_name
}

output "cloudsql_private_ip" {
  description = "Dev Cloud SQL private IP"
  value       = module.cloudsql.private_ip_address
}

output "database_name" {
  description = "Dev database name"
  value       = module.cloudsql.database_name
}

output "database_user" {
  description = "Dev database user"
  value       = module.cloudsql.database_user
}