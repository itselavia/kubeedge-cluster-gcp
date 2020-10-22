provider "google" {
  credentials = file(var.credentials_file_location)
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
  region   = var.region
}

module "config_bucket" {
  source       = "./modules/config_bucket"
  project_name = var.project_name
}

module "kubernetes" {
  source                = "./modules/kubernetes"
  vpc_name              = var.vpc_name
  subnetwork_name       = module.vpc.subnetwork_1_name
  zone                  = var.zone
  k8s_worker_node_count = var.k8s_worker_node_count
  config_bucket         = module.config_bucket.config_bucket_url
}

module "kubeedge" {
  source        = "./modules/kubeedge"
  config_bucket = module.config_bucket.config_bucket_url
  vpc_name              = var.vpc_name
  zone                  = var.zone
  subnetwork_name       = module.vpc.subnetwork_2_name
  edge_node_count = var.edge_node_count
}