resource "google_compute_security_policy" "armor" {
  name = "petclinic-armor-policy"

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-stable', {'sensitivity': 2})"
      }
    }
    description = "Block OWASP SQLi (preconfigured WAF)"
  }

  rule {
    action   = "deny(403)"
    priority = 2000
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('xss-stable', {'sensitivity': 2})"
      }
    }
    description = "Block OWASP XSS (preconfigured WAF)"
  }

  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow"
  }
}
