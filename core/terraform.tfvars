project = "[Your Google Cloud Project]"
company = "[Your company]"

credentials = "[path to credential file]"

compute_regions = {
  us-south1 = {
    zone           = "us-south1-c"
    instance_type  = "e2-micro"
    num_workers    = 2
    max_workers    = 5
    private_subnet = "10.5.1.0/24"
    public_subnet  = "10.5.2.0/24"
    tags           = ["nginx"]
  }
}

