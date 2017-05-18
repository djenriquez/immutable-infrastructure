terraform {
  backend "s3" {
    bucket = "immutability"
    key    = "terraform/demo/consul/terraform.tfstate"
    region = "us-west-2"
  }
}