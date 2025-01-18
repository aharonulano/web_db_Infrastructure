# resource "aws_subnet" "public_eks_sub" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.4.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "${var.aws_region}a"
#
#   tags = {
#     Name = "public-subnet"
#   }
# }
#
# resource "aws_subnet" "private_eks_sub_1" {
#   cidr_block        = "10.0.5.0/24"
#   vpc_id            = aws_vpc.main.id
#   availability_zone = "${var.aws_region}b"
#
#   tags = {
#     Name = "private-eks-subnet_1"
#   }
# }
#
# resource "aws_subnet" "private_eks_sub_2" {
#   cidr_block        = "10.0.6.0/24"
#   vpc_id            = aws_vpc.main.id
#   availability_zone = "${var.aws_region}c"
#   tags = {
#     Name = "private-eks-subnet_2"
#   }
# }
#
#
# locals {
#   policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
# }
#
#
# resource "aws_iam_role" "eks_cluster_role" {
#   name = "eks-role"
#
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "eks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
#
#   tags = {
#     Name = "eks-role"
#   }
# }
#
# resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }
#
# resource "aws_iam_role" "eks_node_role" {
#   name = "eks-node-role"
#
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
#
#   tags = {
#     Name = "eks-node-role"
#   }
# }
#
# resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
#   for_each   = toset(local.policies)
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = each.value
# }
#
# resource "aws_eks_cluster" "main" {
#   name     = "main-eks-cluster"
#   role_arn = aws_iam_role.eks_cluster_role.arn
#
#   vpc_config {
#     subnet_ids = [aws_subnet.private_eks_sub_1.id, aws_subnet.private_eks_sub_2.id]
#   }
# #aws_subnet.private_eks_sub_1.id,
#   tags = {
#     Name = "main-eks-cluster"
#   }
# }
#
#
# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "main-eks-node-group"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = [aws_subnet.public_eks_sub.id, aws_subnet.private_eks_sub_1.id, aws_subnet.private_eks_sub_2.id]
#
#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }
#
#   tags = {
#     Name = "main-eks-node-group"
#   }
# }
#
# # data "aws_eks_cluster_auth" "main" {
# #   name = aws_eks_cluster.main.name
# # }
#
# resource "helm_release" "argocd" {
#   depends_on = [aws_eks_node_group.main]
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "4.5.2"
#
#   namespace = "argocd"
#
#   create_namespace = true
#
#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }
#
#   set {
#     name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#     value = "nlb"
#   }
# }
#
# # data "kubernetes_service" "argocd_server" {
# #   metadata {
# #     name      = "argocd-server"
# #     namespace = helm_release.argocd.namespace
# #   }
# # }