resource "aws_eks_cluster" "titan_eks" {
  name     = "titan-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
    # Allows us to connect to the cluster from our laptop
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  # Ensure the IAM policy is fully attached before creating the cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
