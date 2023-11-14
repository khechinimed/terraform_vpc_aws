### Module Main

provider "aws" {
  region = var.aws_region
}

locals {
  vpc_name = "${var.vpc_name}-vpc"
  vpc_tags = merge (var.tags ,
      {
        Name = local.vpc_name
        Environment = var.environment
      }
    )
}

resource "aws_key_pair" "deployer-key" {
  key_name   = "deployer-key"
  public_key = "${file(var.aws_keypair_file)}"
}

resource "aws_instance" "nat" {
  for_each = var.availability_zones

  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public[each.key].id
  key_name = aws_key_pair.deployer-key.key_name

  tags = {
    Name = "${var.aws_region}${each.key}-ec2"
    Environment = var.environment
    Owner = "Khechini Mohamed"
  }
}
