variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "security_group_id" {}
variable "ami" { default = "ami-00a929b66ed6e0de6" }
variable "instance_type" { default = "t2.micro" }
variable "user_data" { default = "" }
variable "key_name" { default = "vockey" }
