#EKS Cluster role
resource "aws_iam_role" "eks-alt-cluster" {
 name = "eks-alt-cluster"
 tags = merge(var.default_tags, tomap({"Name" = "eks-alt-cluster-sg"}))
 assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
 {
 "Effect": "Allow",
 "Principal": {
 "Service": "eks.amazonaws.com"
 },
 "Action": "sts:AssumeRole"
 }
 ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-alt-cluster-AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role = aws_iam_role.eks-alt-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-alt-cluster-AmazonEKSServicePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
 role = aws_iam_role.eks-alt-cluster.name
}

resource "aws_security_group" "eks-alt-cluster-sg" {
 name = "terraform-eks-alt-cluster"
 description = "Cluster communication with worker nodes"
 vpc_id = module.vpc.vpc_id
 tags = merge(var.default_tags, tomap({"Name" = "eks-alt-cluster-sg"}))

ingress {
   from_port = 0
   to_port   = 65535
   protocol  = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 
 egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#NodeGroup
resource "aws_iam_role" "eks-alt-cluster-nodes" {
 name = "eks-alt-cluster-node"
 tags = merge(var.default_tags, tomap({"Name" = "eks-alt-cluster-ng-sg"}))
 assume_role_policy = jsonencode({
 Statement = [{
 Action = "sts:AssumeRole"
 Effect = "Allow"
 Principal = {
 Service = "ec2.amazonaws.com"
 }
 }]
 Version = "2012-10-17"
 })
}

resource "aws_iam_role_policy_attachment" "eks-alt-cluster-nodes-AmazonEKSWorkerNodePolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 role = aws_iam_role.eks-alt-cluster-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks-alt-cluster-nodes-AmazonEKS_CNI_Policy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
 role = aws_iam_role.eks-alt-cluster-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks-alt-cluster-nodes-AmazonEC2ContainerRegistryReadOnly" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role = aws_iam_role.eks-alt-cluster-nodes.name
}