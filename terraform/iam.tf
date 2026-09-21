resource "google_service_account" "run" {
  account_id   = "petclinic-run"
  display_name = "PetClinic Cloud Run runtime"
}

# Leitura da senha no Secret Manager
resource "google_secret_manager_secret_iam_member" "run_accessor" {
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.run.email}"
}

# Escrita de logs pelo Cloud Run (SA custom não herda permissões de editor)
resource "google_project_iam_member" "run_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.run.email}"
}
