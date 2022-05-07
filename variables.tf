variable "vpc_cidr" {
  type        = string
  description = "CIDR block to build the VPC from"
  default     = "10.0.0.0/20"
}

variable "aws_region" {
  type        = string
  description = "AWS region where the infrastructure will be built out"
  default     = "us-east-1"
}