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

resource "aws_eip" "eip_static" {
  for_each = var.availability_zones
}

resource "aws_eip_association" "eip_assoc" {
  //find all instance ids in the private
  for_each      = var.availability_zones
  instance_id   = aws_instance.public_instance[each.key].id
  allocation_id = aws_eip.eip_static[each.key].id
}

resource "aws_key_pair" "deployer-key" {
  key_name   = "khechini-key"
  public_key = "${file(var.aws_keypair_file)}"
}

resource "aws_instance" "private_instance" {
  for_each = var.availability_zones

  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.private[each.key].id
  key_name = aws_key_pair.deployer-key.key_name
  vpc_security_group_ids = [aws_security_group.name.id]

  source_dest_check = false

  tags = {
    Name = "${var.aws_region}${each.key}-ec2-private"
    Environment = var.environment
    Owner = "Khechini Mohamed"
  }
}

resource "aws_instance" "public_instance" {
  for_each = var.availability_zones

  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public[each.key].id
  key_name = aws_key_pair.deployer-key.key_name
  vpc_security_group_ids = [aws_security_group.name.id]

  source_dest_check = false

  tags = {
    Name = "${var.aws_region}${each.key}-ec2-public"
    Environment = var.environment
    Owner = "Khechini Mohamed"
  }
}