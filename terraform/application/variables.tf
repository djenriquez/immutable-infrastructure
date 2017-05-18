provider "aws" {
    region = "us-west-2"
}

variable "type" {}
variable "tenant" {}
variable "environment" {}
variable "vpc_id" { default="vpc-2e4ef34b" }
variable "ssh_key" {}