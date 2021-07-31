
provider "digitalocean" {
}

provider "kubernetes" {
  load_config_file       = false
  host                   = local.kube_config.host
  token                  = local.kube_config.token
  cluster_ca_certificate = local.kube_config.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = local.kube_config.host
    token                  = local.kube_config.token
    cluster_ca_certificate = local.kube_config.cluster_ca_certificate
  }
}

provider "cloudflare" {
  api_token = local.cloudflare_config.api_token
}
