# Create a subnet
resource "google_compute_subnetwork" "public" {
  # count         = var.subnet_count
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

# Create a subnet
resource "google_compute_subnetwork" "private" {
  # count         = var.subnet_count
  name          = "my-custom-priv-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  private_ip_google_access = true
  network       = google_compute_network.vpc_network.name
}