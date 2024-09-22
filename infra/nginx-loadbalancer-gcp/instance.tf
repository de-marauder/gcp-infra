
# Create instance templates
resource "google_compute_instance_template" "template_app" {
  name         = "template-app"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    echo "Hello from App 1 - Instance $(hostname)" > /var/www/html/index.html
  EOF

  tags = ["allow-health-check", "allow-lb"]
}

# Create instance groups
resource "google_compute_instance_group_manager" "group_app" {
  name               = "group-app"
  base_instance_name = "app"
  zone               = "us-central1-a"
  target_size        = 2

  version {
    instance_template = google_compute_instance_template.template_app.id
  }

  named_port {
    name = "http"
    port = 80
  }
}
