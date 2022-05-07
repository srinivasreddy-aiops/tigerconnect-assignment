locals {
  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 2, 1),
    cidrsubnet(var.vpc_cidr, 2, 2),
    cidrsubnet(var.vpc_cidr, 2, 3),
  ]

  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 4, 0),
    cidrsubnet(var.vpc_cidr, 4, 1),
    cidrsubnet(var.vpc_cidr, 4, 2),
  ]
}