variable "project" {
  default = "barnyard_cloud"
}
variable "env" {
  default = "dev"
}
variable "company" {
  default = "barnyard"
}
variable "ssh_user" {
  description = "(Required) The ssh user of GCP instance"
  type        = string
  default     = "ubuntu"
}

variable "credentials" {
  description = "(Required) Service account credentials from GCP"
  type        = string
}

variable "compute_regions" {
  type = map(any)
  default = {
    us-south1 = {
      zone           = "us-south1-c"
      num_workers    = 2
      max_workers    = 5
      private_subnet = "10.5.1.0/24"
      public_subnet  = "10.5.2.0/24"
      tags           = []
  } }
}

