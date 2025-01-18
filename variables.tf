variable "account" {
  description = "(Required) account ID"
  type        = string
}

variable "profile_name" {
  description = "(Required) profile name"
  type        = string
}

variable "aws_region" {
  description = "(Required) region in which you well deploy your resources"
  type        = string
}

variable "ec2_ami" {
  description = "(Required) ami for ec2 for example aws linux 2 ami"
  type        = string
  #   default = "ami-05576a079321f21f8"
  #   default = "ami-0130c3a072f3832ff"
  #   "ami-01f5f2e96f603b15b"
  default = "ami-01f5f2e96f603b15b"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_key" {
  type      = string
  sensitive = true
}

variable "my_local_ip" {
  type = string
}

variable "cidr_allow_all" {
  type    = string
  default = "1.2.3.4/32"
}

variable "domain_mydevops_link" {
  type    = string
  default = "aurt53link.com"
}
