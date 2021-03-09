variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "environment_name" {
  description = "enter the name of the environment"
  type        = string
  default     = "dev"
}
variable "defined_tags" {
  description = "A map of tags to add to all resources."
  type        = map
  default     = {}
}

variable "project_name" {
  description = "Name of the project, all the resources will have this as suffix"
  default = "sre"   
}

