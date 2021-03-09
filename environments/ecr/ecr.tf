provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">=0.11.0"

 backend "s3" {
	encrypt = true
	bucket = "aws-sre-terraform-state-us-east-1"
	region = "us-east-1"
	key = "project_provisioning/sre.ecr.tfstate"
 }
}


#---------------ECR Repo ----------------------------
resource "aws_ecr_repository" "sre_ecr_repo" {
  name = "sre-ecr-repo"
}


output "sre_ecr_repo_url" {
  value = "${aws_ecr_repository.sre_ecr_repo.repository_url}"
}
