resource "google_compute_address" "external_ip" {
  name = "${var.environment}-${var.name_prefix}-external-ip"
}


resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment}-${var.name_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.environment}-${var.name_prefix}-public-subnet"
  ip_cidr_range = "${var.public_subnet}"
  network       = google_compute_network.vpc_network.self_link

  // Enables VMs in this subnet to be assigned public IPs
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.environment}-${var.name_prefix}-private-subnet"
  ip_cidr_range = "${var.private_subnet}"
  network       = google_compute_network.vpc_network.self_link

  // Ensures VMs in this subnet cannot be assigned public IPs
  private_ip_google_access = true
}
