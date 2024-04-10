provider "google" {
  project     = var.project
  region      = "us-south1"
  credentials = file(var.credentials)
}

module "vpc" {
  source          = "../modules/vpc"
  company         = var.company
  compute_regions = var.compute_regions
}

module "compute" {
  source            = "../modules/compute"
  for_each          = var.compute_regions
  network_self_link = module.vpc.vpc
  project           = var.project
  company           = var.company
  ssh_user          = var.ssh_user

  region         = each.key
  zone           = each.value.zone
  machine_type   = each.value.instance_type
  tags           = each.value.tags
  num_workers    = each.value.num_workers
  max_workers    = each.value.max_workers
  public_subnet  = each.value.public_subnet
  private_subnet = each.value.private_subnet

  depends_on = [module.vpc.vpc]
}
