terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
  backend "s3" {
    bucket = "pgr301-2021-terraform-state"
    key    = "kandidat_2019_unik/apprunner-a-new-state.state"
    region = "eu-north-1"
  }
}