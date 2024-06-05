locals {
  user_management_repo_url = "https://github.com/hamidreza-ygh/tenant-manager.git"
  user_management_repo_path = "deployment"
  user_interface_repo_url = "https://github.com/hamidreza-ygh/tenant-ui.git"
  user_interface_repo_path = "deployment"
  app_name = "tenant-manager"
  app_namespace = "control-tier"
}

resource "helm_release" "argo_cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.52.0"
  timeout          = 1200
  create_namespace = true
  namespace        = "argocd"
  lint             = true
  wait             = true

  depends_on = [
    local_sensitive_file.my_sks_kubeconfig_file,
    exoscale_sks_nodepool.my_sks_nodepool
  ]
}

resource "helm_release" "argo_cd_app" {
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = "1.4.1"
  timeout          = 1200
  create_namespace = true
  namespace        = "argocd"
  lint             = true
  wait             = true
  values = [templatefile("app-values.yaml", {
    user_management_repo_url = local.user_management_repo_url
    user_management_repo_path = local.user_management_repo_path
    user_interface_repo_url = local.user_interface_repo_url
    user_interface_repo_path = local.user_interface_repo_path
    app_name = local.app_name
    app_namespace = local.app_namespace
  })]

  depends_on = [
    kubernetes_namespace.control-tier,
    # time_sleep.wait_for_cert,
    # time_sleep.wait_for_manager_cert,
    # kubectl_manifest.tenant_ui_cert,
    kubernetes_secret.ui-secrets,
    kubernetes_secret.tenant-manager-secrets,
    helm_release.argo_cd
  ]
}

# resource "kubectl_manifest" "tenant_ui_cert" {
#   depends_on = [
#     kubernetes_namespace.control-tier,
#     time_sleep.wait_for_clusterissuer
#   ]
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: tenant-ui-cert
#   namespace: control-tier
# spec:
#   secretName: tenant-ui-cert
#   issuerRef:
#     name: cloudflare-prod
#     kind: ClusterIssuer
#   dnsNames:
#     - ${var.tenant_ui_domain}
#     - api.tenantodo.life
# YAML
# }

# resource "time_sleep" "wait_for_cert" {
#   depends_on = [ kubectl_manifest.tenant_ui_cert ]
#   create_duration = "40s"
# }


# resource "kubectl_manifest" "tenant_manager_cert" {
#   depends_on = [
#     kubernetes_namespace.control-tier,
#     time_sleep.wait_for_clusterissuer
#   ]
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: tenant-manager-cert
#   namespace: control-tier
# spec:
#   secretName: tenant-manager-cert
#   issuerRef:
#     name: cloudflare-prod
#     kind: ClusterIssuer
#   dnsNames:
#     - api.tenantodo.life
# YAML
# }

# resource "time_sleep" "wait_for_manager_cert" {
#   depends_on = [ kubectl_manifest.tenant_manager_cert ]
#   create_duration = "30s"
# }