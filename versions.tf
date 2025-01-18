terraform {
  required_version = "~>1.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    # helm = {
    #   source  = "terraform/helm"
    #   version = "3.8.2"
    # }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }
}
