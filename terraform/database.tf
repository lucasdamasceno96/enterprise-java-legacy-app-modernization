resource "google_sql_database_instance" "petclinic" {
  name             = "petclinic"
  database_version = var.postgres_version
  region           = var.region

  settings {
    tier = var.postgres_tier

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc.id
      enable_private_path_for_google_cloud_services = true
    }
  }

  deletion_protection = true

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "petclinic" {
  name     = "petclinic"
  instance = google_sql_database_instance.petclinic.name
}

resource "google_sql_user" "petclinic" {
  name     = "petclinic"
  instance = google_sql_database_instance.petclinic.name
  password = random_password.db.result
}
