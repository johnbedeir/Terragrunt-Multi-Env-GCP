resource "google_compute_router" "router" {
  name    = "${var.environment}-${var.name_prefix}-router"
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.environment}-${var.name_prefix}-nat-gateway"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
