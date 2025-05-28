provider "google" {
  project     = "plated-epigram-452709-h6"
  region      = "us-central1"
}

resource "google_compute_instance" "harness_vm" {
  name         = "harness-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      sudo apt update
      sudo apt install -y apache2
      sudo systemctl start apache2
    EOT
  }

  tags = ["web"]
}
terraform {
  backend "gcs" {
    bucket = "harness-migrate"
    prefix = "vm-instance/state"
  }
}
