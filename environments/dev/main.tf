provider "aws" {
  region = "us-east-1"
}


terraform {
  required_version = ">=0.11.0"

 backend "s3" {
	encrypt = true
	bucket = "aws-sre-terraform-state-us-east-1"
	region = "us-east-1"
	key = "project_provisioning/sre.dev.tfstate"
 }
}


module "core-infra" {
  source              = "../../modules/core-infra"
  environment_name    = "dev"
  defined_tags = {
    ApplicationID             = "SRE"
    CreatedBy                 = "Santosh Marepally"
    InfrastructureTier        = "Development"
  }
}


output "alb_host_name" {
  value = module.core-infra.alb_host_name
}

