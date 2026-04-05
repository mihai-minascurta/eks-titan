# ------------------------------------------------------------------------------
# THE EKS MANAGED NODE GROUP (The Muscle)
# ------------------------------------------------------------------------------
resource "aws_eks_node_group" "titan_nodes" {
  # 1. Link the Muscle to the Brain
  cluster_name    = aws_eks_cluster.titan_eks.name
  node_group_name = "titan-worker-nodes"
  
  # 2. Attach the IAM Passport (From Day 1)
  node_role_arn   = aws_iam_role.eks_node_role.arn

  # 3. ENTERPRISE SECURITY: Place nodes ONLY in the Private Subnets
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # 4. Cost & Compute Specs
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  # 5. Auto-Scaling Configuration
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Terraform must wait for IAM policies to exist before booting servers
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]
}
