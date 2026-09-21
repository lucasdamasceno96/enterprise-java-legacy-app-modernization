terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "gcs" {
    bucket = "ldp21k-labs-tfstate"
    prefix = "workloads/petclinic"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "project" {}
