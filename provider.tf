terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
 region = "us-east-1"
}



# data "aws_eks_cluster_auth" "eks-alt-cluster-auth" {
#  name = "eks-alt-cluster"
# }
# provider "kubernetes" {
#  host = aws_eks_cluster.eks-alt-cluster.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-alt-cluster.certificate_authority[0].data)
#  token = data.aws_eks_cluster_auth.eks-alt-cluster-auth.token
# #  load_config_file = false
# }