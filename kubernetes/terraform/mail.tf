provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  zone               = "${var.zone}"
  initial_node_count = 2

  node_config {
    disk_size_gb = 20
    machine_type = "g1-small"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata {
      disable-legacy-endpoints = "true"
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.id} --zone ${var.zone} --project ${var.project}"
  }
}

resource "google_compute_firewall" "firewall_kuber" {
  name    = "default-allow-kubernode"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-33000"]
  }

  source_ranges = ["0.0.0.0/0"]
}
