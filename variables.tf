variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_keypair_file" {
  type        = string
  description = "Path of the public key"
  default     = "labsuser.pem"
}

variable "cidr_block" {
  type        = string
  description = "Le bloc CIDR /16 du VPC est recommandé"
  default     = "10.0.0.0/16"  # Default CIDR block for the VPC
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "aws-vpc" 
}

variable "environment" {
  type        = string
  description = "VPC Environment Label"
  default     = "Learning" 
}

variable "tags" {
  type    = map(string)
  default = {
    Owner = "khechini@cloud.com"
    Project = "terraform-aws-vpc"
  }
}

variable "availability_zones" {
  type = map(string)
  default = {
    "a" = 0,
    "b" = 1,
    "c" = 2,
  }
}