variable "account" {
  description = "(Required) account ID"
  type        = string
  default     = "put/here/your/account/id"
}

variable "profile_name" {
  description = "(Required) profile name"
  type        = string
  default     = "defualt"
}

variable "aws_region" {
  description = "(Required) region in which you well deploy your resources"
  type        = string
  default     = "eu-west-1"
}

variable "db_user_name" {
  description = "(Required)"
  type        = string
  default     = "aumichome"
  sensitive   = true
}

variable "db_password" {
  description = "(Required)"
  type        = string
  default     = "assignment"
  sensitive   = true
}

variable "ec2_ami" {
  description = "(Required) ami for ec2 for example aws linux 2 ami"
  type        = string
  default     = "ami-01f5f2e96f603b15b"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_key" {
  type    = string
  default = "~/.ssh/ec2_key.pub"
  # sensitive = true
}

variable "my_local_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cidr_allow_all" {
  type    = string
  default = "1.2.3.4/32"
}
