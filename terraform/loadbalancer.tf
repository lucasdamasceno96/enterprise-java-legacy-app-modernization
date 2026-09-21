resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "petclinic-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.petclinic.name
  }
}

resource "google_compute_backend_service" "petclinic" {
  name                  = "petclinic-backend"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 30

  security_policy = google_compute_security_policy.armor.id

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

resource "google_compute_url_map" "petclinic" {
  name            = "petclinic-url-map"
  default_service = google_compute_backend_service.petclinic.id
}

# Nota Arquitetural: Para fins de laboratório, o Load Balancer opera em HTTP.
# Em um ambiente de produção real, substituiríamos por target_https_proxy acoplado
# a um certificado SSL gerenciado.
resource "google_compute_target_http_proxy" "petclinic" {
  name    = "petclinic-http-proxy"
  url_map = google_compute_url_map.petclinic.id
}

resource "google_compute_global_address" "lb_ip" {
  name = "petclinic-lb-ip"
}

resource "google_compute_global_forwarding_rule" "petclinic" {
  name                  = "petclinic-http-fwd"
  target                = google_compute_target_http_proxy.petclinic.id
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.lb_ip.address
}
