include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/"
}

inputs               = {
  environment        = "prod"
  public_subnets     = "10.1.1.0/24"
  private_subnets    = "10.1.2.0/24"
}
