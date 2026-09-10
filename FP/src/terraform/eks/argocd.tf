# -----------------------------------------------------------------------------
# ArgoCD installation via the official Helm chart (argo/argo-helm)
# Exposed on: argocd.<name>.<zone_name>  (e.g. argocd.student13.devops13.test-danit.com)
#
# TLS is terminated on the NLB in front of ingress-nginx using the ACM certificate
# (see ingress_controller.tf / acm.tf), the same way as for the demo app, so
# ArgoCD's own ingress does not need a TLS block - it just needs to accept
# plain HTTP from the ingress controller. That's why server.insecure=true.
# -----------------------------------------------------------------------------

locals {
  argocd_hostname = "argocd.${local.domain_name}"
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.18"
  namespace        = "argocd"
  create_namespace = true


  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  # Ingress for the ArgoCD UI / API
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.hosts[0]"
    value = local.argocd_hostname
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTP"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "false"
  }

  depends_on = [
    helm_release.nginx_ingress,
    module.acm,
  ]
}

output "argocd_url" {
  description = "URL for the ArgoCD UI"
  value       = "http://${local.argocd_hostname}"
}

output "argocd_initial_admin_password_cmd" {
  description = "Command to fetch the initial admin password once the cluster is up"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
}
