terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sous-chefs"
    workspaces {
      name = "terraform-auto-release"
    }
  }
}

resource "digitalocean_project" "auto-release" {
  name        = "auto-release-${var.environment}"
  description = "A project to hold all resources related to the running and monitoring of the auto release system"
  purpose     = "Service or API"
  environment = var.environment
}

module "auto-release_cluster" {
  source = "./modules/do_kubernetes_cluster"
}

locals {
  kube_config = {
    host  = module.auto-release_cluster.kubernetes_cluster.endpoint
    token = module.auto-release_cluster.kubernetes_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      module.auto-release_cluster.kubernetes_cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

module "kubernetes_core_cluster_services" {
  source            = "./modules/core_cluster_services"
  cloudflare_config = local.cloudflare_config
  kube_config       = local.kube_config
}
