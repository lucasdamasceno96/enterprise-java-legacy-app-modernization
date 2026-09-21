resource "google_cloud_run_v2_service" "petclinic" {
  name     = "petclinic"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = google_service_account.run.email

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.petclinic.repository_id}/petclinic:${var.image_tag}"

      ports {
        container_port = 8080
      }

      env {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "postgres"
      }
      env {
        name  = "POSTGRES_URL"
        value = "jdbc:postgresql://${google_sql_database_instance.petclinic.private_ip_address}:5432/petclinic"
      }
      env {
        name  = "POSTGRES_USER"
        value = "petclinic"
      }
      env {
        name = "POSTGRES_PASS"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password.secret_id
            version = "latest"
          }
        }
      }
    }

    vpc_access {
      egress = "PRIVATE_RANGES_ONLY"
      network_interfaces {
        network    = google_compute_network.vpc.id
        subnetwork = google_compute_subnetwork.cloudrun_subnet.id
      }
    }
  }
}
