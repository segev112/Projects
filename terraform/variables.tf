variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "project-eks"
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "project_ecr"
}
