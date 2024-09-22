# Create Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.vpc_network.id
  region  = var.region
}

# Create Cloud NAT Gateway
resource "google_compute_router_nat" "nat_gateway" {
  name   = "cloud-nat"
  router = google_compute_router.nat_router.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"
  # nat_ip_allocate_option = "MANUAL_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.private.name
    source_ip_ranges_to_nat = "ALL_IP_RANGES"
  }

  log_config {
    enable = true
    filter = "ALL"
  }
}