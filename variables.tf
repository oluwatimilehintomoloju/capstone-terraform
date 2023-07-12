variable "names" {
  type = list(any)

  default = ["cmgt-ui", "cmgt-backend"]
}

variable "cluster_name" {
  type    = string
  default = "capstone-eks-cluster"
}

variable "node_group_name" {
    type = string
    default = "capstone-eks-terraform"
}

variable "iam_profile_name" {
    type = string
    default = "capstone-eks-worker-profile"
}

variable "launch_conf_name" {
  type = string 
  default = "capstone-terraform-eks"
}