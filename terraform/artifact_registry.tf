resource "google_artifact_registry_repository" "petclinic" {
  location      = var.region
  repository_id = "petclinic"
  format        = "DOCKER"
}
