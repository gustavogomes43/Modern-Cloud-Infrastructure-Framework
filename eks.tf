resource "aws_eks_cluster" "main" {
  name     = "Enterprise-Modernization-Cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.eks_private_1.id, aws_subnet.eks_private_2.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}

resource "aws_eks_fargate_profile" "main" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "fp-default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [aws_subnet.eks_private_1.id, aws_subnet.eks_private_2.id]

  selector {
    namespace = "default"
  }
  selector {
    namespace = "kube-system"
  }
}
