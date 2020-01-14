terraform {
    backend "s3" {
    bucket = "lab-terraform-iis-tfstate"
    region = "us-east-1"
    key    = "lab_terraform_iis.state"
  }
}

provider "aws" {
  region = "${var.region}"
}
