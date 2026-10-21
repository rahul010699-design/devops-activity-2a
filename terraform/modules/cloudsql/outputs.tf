output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.postgres.name
}

output "private_ip_address" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "database_name" {
  description = "PostgreSQL database name"
  value       = google_sql_database.database.name
}

output "database_user" {
  description = "PostgreSQL database user"
  value       = google_sql_user.user.name
}
