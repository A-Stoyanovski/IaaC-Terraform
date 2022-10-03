variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet-public-cidr" {
  type = string
}

variable "subnet-private-cidr" {
  type = string
}

variable "all-traffic-cidr" {
  type = string
}

variable "subnet-private-name" {
  type = string
}

variable "subnet-public-name" {
  type = string
}

variable "eip-name" {
  type = string
}

variable "igw-name" {
  type = string
}

variable "nat-name" {
  type = string
}

variable "public-rt-name" {
  type = string
}

variable "private-rt-name" {
  type = string
}