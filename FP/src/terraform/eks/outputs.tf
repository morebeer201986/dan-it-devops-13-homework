output "app_url" {
  description = "URL where the demo app from item 1/4 will be reachable (once its Ingress is applied via ArgoCD)"
  value       = "http://app.${local.domain_name}"
}

output "cluster_name" {
  value = aws_eks_cluster.danit.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.danit.endpoint
}
