resource "google_monitoring_dashboard" "petclinic" {
  dashboard_json = jsonencode({
    displayName = "PetClinic - Cloud Run / Cloud SQL"
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title = "Cloud Run - Latência (p99)"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"run.googleapis.com/request_latencies\" AND resource.labels.service_name=\"petclinic\""
                  aggregation = {
                    perSeriesAligner   = "ALIGN_PERCENTILE_99"
                    crossSeriesReducer = "REDUCE_PERCENTILE_99"
                    alignmentPeriod    = "60s"
                  }
                }
              }
            }]
            timeshiftDuration = "0s"
            yAxis             = { label = "y1Axis" }
          }
        },
        {
          title = "Cloud Run - Utilização de CPU"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"run.googleapis.com/container/cpu/utilizations\" AND resource.labels.service_name=\"petclinic\""
                  aggregation = {
                    perSeriesAligner = "ALIGN_MEAN"
                    alignmentPeriod  = "60s"
                  }
                }
              }
            }]
            timeshiftDuration = "0s"
            yAxis             = { label = "y1Axis" }
          }
        },
        {
          title = "Cloud SQL - Conexões ativas (Postgres backends)"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" AND resource.labels.database_id=\"petclinic\""
                  aggregation = {
                    perSeriesAligner = "ALIGN_MEAN"
                    alignmentPeriod  = "60s"
                  }
                }
              }
            }]
            timeshiftDuration = "0s"
            yAxis             = { label = "y1Axis" }
          }
        }
      ]
    }
  })
}
