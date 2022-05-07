module "vpc_community" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.70"

  name            = "tigerconnect-vpc"
  cidr            = var.vpc_cidr
  azs             = slice(sort(data.aws_availability_zones.available.names), 0, 3)
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name      = "tigerconnect-vpc"
    Terraform = "true"
  }
}