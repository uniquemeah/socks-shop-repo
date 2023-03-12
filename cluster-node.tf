resource "aws_eks_node_group" "eks-alt-cluster-nodes" {
 cluster_name = aws_eks_cluster.eks-alt-cluster.name
 node_group_name = "eks-alt-cluster-nodes"
 node_role_arn = aws_iam_role.eks-alt-cluster-nodes.arn
 subnet_ids = module.vpc.private_subnets
 instance_types = ["t3.medium"]
 tags = merge(var.default_tags, tomap({"Name" = "eks-alt-cluster-nodes"}))
 scaling_config {
 desired_size = 3
 max_size = 3
 min_size = 3
 }
# Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
 # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
 depends_on = [
 aws_iam_role_policy_attachment.eks-alt-cluster-nodes-AmazonEKSWorkerNodePolicy,
 aws_iam_role_policy_attachment.eks-alt-cluster-nodes-AmazonEKS_CNI_Policy,
 aws_iam_role_policy_attachment.eks-alt-cluster-nodes-AmazonEC2ContainerRegistryReadOnly,
 ]
}

# Workaround for tagging AWS Managed EKS nodegroups
locals {
 asg_name = aws_eks_node_group.eks-alt-cluster-nodes.resources[0]["autoscaling_groups"][0]["name"]
}

resource "null_resource" "add_custom_tags_to_asg" {
 triggers = {
 node_group = local.asg_name
 }
 provisioner "local-exec" {
 command = "aws autoscaling create-or-update-tags --tags ResourceId=${local.asg_name},ResourceType=auto-scaling-group,Key=”Name”,Value=”EKS-MANAGED-NODEGROUP-NODE”,PropagateAtLaunch=true"
 }

 provisioner "local-exec" {
 command = "aws autoscaling create-or-update-tags --tags ResourceId=${local.asg_name},ResourceType=auto-scaling-group,Key=”Custodian-Scheduler-StopTime”,Value=”off”,PropagateAtLaunch=true"
 }


depends_on = [
 aws_eks_node_group.eks-alt-cluster-nodes
 ]
}