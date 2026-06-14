terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "terraform-state-danit-devops-shultz14"
    key    = "shultz14/terraform.tfstate" 
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_vpc" "default" {
  default = true
}

module "nginx_server" {
  source = "./modules/nginx_server"

  vpc_id             = data.aws_vpc.default.id 
  list_of_open_ports = [80, 22]
}
