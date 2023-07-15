variable "names" {
  type = list(any)

  default = ["cmgt-ui", "cmgt-backend"]
}

variable "cluster_name" {
  type    = string
  default = "capstone-eks-cluster"
}

variable "node_group_name" {
  type    = string
  default = "capstone-eks-terraform"
}

variable "iam_profile_name" {
  type    = string
  default = "capstone-eks-worker-profile"
}

variable "az" {
  type    = string
  default = "eu-west-2a"
}

variable "subnet_type" {
  type    = string
  default = "public"
}

variable "organisation" {
  type    = string
  default = "bkss"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}