variable "project" {
  type = string
}

variable "company" {
  type = string
}

variable "network_self_link" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "num_workers" {
  type = number
}

variable "max_workers" {
  type = number
}

variable "machine_type" {
  type = string
}

variable "tags" {
  type = set(any)
}

variable "private_subnet" {
  type = string
}

variable "public_subnet" {
  type = string
}
