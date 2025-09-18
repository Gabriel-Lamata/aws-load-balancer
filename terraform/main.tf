provider "aws" { 
  region                   = "us-east-1"
  shared_config_files      = [".aws/config"]
  shared_credentials_files = [".aws/credentials"]
  profile                  = "iac"
}

# --- MÓDULO NETWORK ---
module "network" {
  source = "./modules/network"
}

# --- MÓDULO LOAD BALANCER ---
module "loadbalancer" {
  source            = "./modules/loadbalancer"
  vpc_id            = module.network.vpc_id
  subnets           = module.network.subnets
  security_group_id = module.network.security_group_id
  user_data         = file("./scripts/user_data.sh")
}
