include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/"
}

inputs               = {
  environment        = "dev"
  public_subnets     = "10.0.1.0/24"
  private_subnets    = "10.0.2.0/24"
}