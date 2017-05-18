terraform {
  backend "s3" {
    bucket = "immutability"
    key    = "terraform/demo/application/terraform.tfstate"
    region = "us-west-2"
  }
}