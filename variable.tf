variable "AWS_REGION" {
 default = "us-east-1"
}

variable "AWS_PROFILE" {
 default = "eks-alt"
}

variable "cluster_name" {
 default = "eks-alt-cluster"
 type = string
}

# Global var file.
variable "default_tags" {
 type = map
 description = "Tags used to identify the project and environment"
 default = {}
}