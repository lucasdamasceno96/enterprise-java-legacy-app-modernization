resource "random_password" "db" {
  length  = 24
  special = true
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "petclinic-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db.result
}
