variable "names" {
  type = list(any)

  default = ["cmgt-ui", "cmgt-backend"]
}

variable "cluster_name" {
  type    = string
  default = "capstone-eks-cluster"
}

variable "node_group_sg_name" {
    type = string
    default = "capstone-eks-terraform"
}