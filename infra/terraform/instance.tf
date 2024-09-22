################################  Web Server  #########################################################

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.public.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

cat <<EOL>> .env
VITE_APP_HOSTNAME=$(hostname)
VITE_APP_API_HOSTNAME=${google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip}
EOL

docker run -d \
  --name my-react-app \
  --env-file .env \
  -p 3000:3000 \
  demarauder/test-frontend:latest

  EOF

  tags = ["allow-health-check", "allow-lb", "allow-web"]
}

################################  App Server  #########################################################

resource "google_compute_instance" "app_server" {
  name         = "app-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.private.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

cat <<EOL>> .env
DB_HOST=${google_compute_instance.db_server.network_interface[0].network_ip}
DB_PASSWORD=${var.db_password}
DB_USER=${var.db_user}
DB_NAME=${var.db_name}
EOL

docker run -d --name backend -p 5000:5000 --env-file .env demarauder/test-backend:latest

  EOF

  tags = ["allow-health-check", "allow-lb", "allow-backend"]
}

################################  DB Server  #########################################################

resource "google_compute_instance" "db_server" {
  name         = "db-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.private.id
    access_config {}
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mkdir -p /data/db
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=${var.db_password} -v /data/db:/var/lib/mysql  -p 3306:3306 -d  mysql:5.7.44

docker exec -i mysql-container mysql -u root --password=${var.db_password} <<EOL
CREATE DATABASE test_db;
USE test_db;

CREATE TABLE test_table (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255)
);

INSERT INTO test_table (message) VALUES ('Hello from MySQL!');
EOL


# End of script
  EOF

  tags = ["allow-health-check", "allow-lb", "allow-db"]
}


output "web_ip" {
  value = google_compute_instance.web_server.network_interface
}
output "backend_ip" {
  value = google_compute_instance.app_server.network_interface
}
output "db_ip" {
  value = google_compute_instance.db_server.network_interface
}