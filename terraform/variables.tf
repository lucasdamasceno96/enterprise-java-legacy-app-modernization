variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "ldp21k-labs"
}

variable "region" {
  description = "GCP region for Cloud Run, Cloud SQL and Artifact Registry"
  type        = string
  default     = "us-central1"
}

variable "postgres_version" {
  description = "Cloud SQL PostgreSQL major version"
  type        = string
  default     = "POSTGRES_15"
}

variable "postgres_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-g1-small"
}

variable "image_tag" {
  description = "Container image tag deployed to Cloud Run"
  type        = string
  default     = "latest"
}
