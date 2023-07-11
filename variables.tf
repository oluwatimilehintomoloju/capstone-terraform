variable "names" {
  type = list(any)

  default = ["cmgt-ui", "cmgt-backend"]
}

variable "cluster_name" {
  type    = string
  default = "capstone-eks-cluster"
}