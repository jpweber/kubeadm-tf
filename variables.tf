variable "aws_region" {
  type    = "string"
  default = "us-east-2"
}

variable "aws_profile" {
  type    = "string"
  default = ""
}

variable "key_name" {
  type = "string"
  default = "id_rsa"
}

variable "public_subnet_blocks" {
  type        = "map"
  description = "CIDR blocks for each subnet"

  default = {
    "0" = "10.1.1.0/24"
    # "1" = "10.1.2.0/24"
    # "2" = "10.1.3.0/24"
  }
}

variable "private_subnet_blocks" {
  type        = "map"
  description = "Calico CIDR blocks for each subnet"

  default = {
    "0" = "192.168.0.0/16"
  }
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "CIRD blocks for vpc"
  default     = "10.1.0.0/16"
}

variable "stage" {
  type = "string"
  default = "staging"
}

variable "route53_internal_domain" {
  type    = "string"
  default = ""
}

variable "num_public_subnets" {
  default = 1
}

variable "num_private_subnets" {
  type    = "string"
  default = 0
}

variable "num_nodes" {
  type    = "string"
  default = ""
}

variable "max_nodes" {
  type    = "string"
  default = "19"
}

variable "control_plane_num" {
  type    = "string"
  default = 2
}

variable "nodes_num" {
  type    = "string"
  default = 2
}

variable "k8s_token" {
  type = "string"
}

variable "route53_zone_id" {
  type = "string"
  default = "Z22YMRMWUEH9KT"
}

variable "route53_elb_cname" {
  type = "string"
  default = "k8s.supercomputerrobot.com"
}