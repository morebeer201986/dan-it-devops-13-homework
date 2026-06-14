variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "list_of_open_ports" {
  description = "List of ports to open in the security group"
  type        = list(number)
}
