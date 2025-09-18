output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnets" {
  value = [aws_subnet.sn_pub_az1a.id, aws_subnet.sn_pub_az1b.id]
}

output "security_group_id" {
  value = aws_security_group.vpc_sg_pub.id
}
