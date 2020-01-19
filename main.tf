terraform {
  backend "s3" {
    bucket = "lab-terraform-iis-apache-tfstate"
    region = "us-east-1"
    key    = "lab_terraform_iis-apache.state"
  }
}

provider "aws" {
  region = "${var.region}"
}
