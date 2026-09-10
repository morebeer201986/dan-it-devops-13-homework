resource "aws_eks_node_group" "danit" {
  cluster_name    = aws_eks_cluster.danit.name
  node_group_name = var.name
  node_role_arn   = aws_iam_role.danit-node.arn
  subnet_ids = var.subnets_ids

  launch_template {
    name    = aws_launch_template.node_template.name
    version = aws_launch_template.node_template.latest_version
  }

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  labels = {
    "node-type" : "tests"
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = merge(
    var.tags,
    { Name = "${var.name}-node-group" }
  )
}

resource "aws_launch_template" "node_template" {
  name_prefix = "vshuleshko13-kubelet-"
  
  user_data = base64encode(<<-EOF
  MIME-Version: 1.0
  Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

  --==MYBOUNDARY==
  Content-Type: text/x-shellscript; charset="us-ascii"

  #!/bin/bash
  /etc/eks/bootstrap.sh vshuleshko13 \
    --use-max-pods false \
    --kubelet-extra-args '--max-pods=110'

  --==MYBOUNDARY==--
  EOF
  )
}
