# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "AWS_REGION" {
  type = string
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "vpc_cidr" {
  description = "IP range of EKS cluster, for example 192.168.1.0/24"
  type = string
}

variable "vpc_private_subnets" {
  description = "IP range of private subnets, ex: [192.168.1.0/27, 192.168.1.32/27, 192.168.1.64/27]"
  type = list(string)
}

variable "vpc_public_subnets" {
  description = "IP range of public subnets, ex: [192.168.1.96/27, 192.168.1.128/27, 192.168.1.160/27]"
  type = list(string)
}

variable "eks_node_min_size" {
  description = "Minimum number of worker nodes, ex: 1"
  type = number
}

variable "eks_node_max_size" {
  description = "Maximum number of worker nodes, ex: 5"
  type = number
}

variable "eks_node_desired_size" {
  description = "Desired number of worker nodes, ex: 2"
  type = number
}

variable "eks_node_min_size_ng1" {
  description = "Minimum number of worker nodes for node group 1, ex: 1"
  type = number
}

variable "eks_node_max_size_ng1" {
  description = "Maximum number of worker nodes for node group 1, ex: 5"
  type = number
}

variable "eks_node_desired_size_ng1" {
  description = "Desired number of worker nodes for node group 1, ex: 2"
  type = number
}
