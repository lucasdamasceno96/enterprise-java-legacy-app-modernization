resource "google_compute_network" "vpc" {
  name                    = "petclinic-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Subnet dedicada ao Direct VPC Egress do Cloud Run (mesma região do serviço)
resource "google_compute_subnetwork" "cloudrun_subnet" {
  name          = "petclinic-cloudrun-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.10.0.0/28"
}

# Faixa reservada para o IP privado do Cloud SQL (Private Services Access)
resource "google_compute_global_address" "cloudsql_private_range" {
  name          = "petclinic-cloudsql-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_range.name]
}

# Firewall: permite apenas 5432 vindo da subnet do Cloud Run (egress dedicada)
resource "google_compute_firewall" "allow_cloudrun_to_cloudsql" {
  name      = "petclinic-cloudrun-to-cloudsql-5432"
  network   = google_compute_network.vpc.id
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = [google_compute_subnetwork.cloudrun_subnet.ip_cidr_range]
}
