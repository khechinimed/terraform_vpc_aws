data "aws_ami" "ami" {

    most_recent = true
    owners = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn-ami-vpc-nat-2018.03.0.2021*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

}

// create ami with ubuntu 20.04
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}