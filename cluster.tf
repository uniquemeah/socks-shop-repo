resource "aws_eks_cluster" "eks-alt-cluster" {
 name = var.cluster_name
 role_arn = aws_iam_role.eks-alt-cluster.arn
 tags = merge(var.default_tags, tomap({"Name" = "eks-alt-cluster"}))
 vpc_config {
 security_group_ids = [aws_security_group.eks-alt-cluster-sg.id]
 subnet_ids = module.vpc.private_subnets
 endpoint_private_access = "true"
 endpoint_public_access = "true"
 }

depends_on = [
 aws_iam_role_policy_attachment.eks-alt-cluster-AmazonEKSClusterPolicy,
 aws_iam_role_policy_attachment.eks-alt-cluster-AmazonEKSServicePolicy,
 ]
}


