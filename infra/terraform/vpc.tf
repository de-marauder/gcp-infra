# Create a VPC
resource "google_compute_network" "vpc_network" {
  name                            = var.project_id
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = false
}