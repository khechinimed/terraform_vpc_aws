# outputs.tf
output "nat_pub_ips" {
  value = [for ec2 in aws_instance.public_instance : ec2.public_ip]
}