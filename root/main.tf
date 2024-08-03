module "vpc" {
  source = "../modules/vpc"
}

# module "nat" {
#   source              = "../modules/nat"
#   public_subnet_id    = module.vpc.public_subnet_id
#   private_subnet_id   = module.vpc.private_subnet_id
#   vpc_id              = module.vpc.vpc_id
#   internet_gateway_id = module.vpc.internet_gateway_id
# }

module "securitygroup" {
  source = "../modules/securitygroup"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "../modules/ec2"
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  frontend_sg_id    = module.securitygroup.frontend_sg_id
  backend_sg_id     = module.securitygroup.backend_sg_id

}
