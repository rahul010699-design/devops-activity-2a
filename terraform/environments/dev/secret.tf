resource "random_password" "database" {
  length           = 24
  special          = true
  override_special = "-_"
}

resource "google_secret_manager_secret" "database_password" {
  secret_id = "${var.database_instance_name}-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = random_password.database.result
}
