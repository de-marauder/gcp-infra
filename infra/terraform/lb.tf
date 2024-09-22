
# # Create health checks
# resource "google_compute_health_check" "health_check" {
#   name               = "http-health-check"
#   check_interval_sec = 5
#   timeout_sec        = 5
#   http_health_check {
#     port = 80
#   }
# }

# # Create backend services
# resource "google_compute_backend_service" "backend_app" {
#   name          = "backend-app"
#   health_checks = [google_compute_health_check.health_check.id]
#   port_name     = "http"
#   protocol      = "HTTP"

#   backend {
#     group = google_compute_instance_group_manager.group_app.instance_group
#   }
# }

# # Create URL map
# resource "google_compute_url_map" "url_map" {
#   name            = "my-url-map"
#   default_service = google_compute_backend_service.backend_app.id

#   host_rule {
#     hosts        = ["app.example.com"]
#     path_matcher = "app"
#   }

#   path_matcher {
#     name            = "app"
#     default_service = google_compute_backend_service.backend_app.id
#   }
# }

# # Create HTTP proxy
# resource "google_compute_target_http_proxy" "http_proxy" {
#   name    = "my-target-http-proxy"
#   url_map = google_compute_url_map.url_map.id
# }

# # Create global forwarding rule
# resource "google_compute_global_forwarding_rule" "forwarding_rule" {
#   name       = "my-forwarding-rule"
#   target     = google_compute_target_http_proxy.http_proxy.id
#   port_range = "80"
# }

# # Output the load balancer IP
# output "load_balancer_ip" {
#   value = google_compute_global_forwarding_rule.forwarding_rule.ip_address
# }