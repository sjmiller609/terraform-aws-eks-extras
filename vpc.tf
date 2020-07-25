module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "2.43.0"

  create_vpc = true

  name = "${var.deployment_id}-vpc"

  # /16 is the maximum supported size for an AWS VPC
  cidr = "10.0.0.0/16"

  azs = local.azs

  # Each of these subnets has 16382 IPs
  private_subnets = ["10.0.128.0/18", "10.0.192.0/18", "10.0.64.0/18"]
  # Generally, the public subnets are only needed
  # for load balancers and NAT, so we allocate smaller
  # subnets, with 1022 hosts each.
  public_subnets = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  # Unallocated subnets for future use
  #
  # 10.0.12.0/22
  # 10.0.16.0/20
  # 10.0.32.0/19

  enable_nat_gateway = true
  single_nat_gateway = false

  # "
  # When you enable endpoint private access for your cluster, Amazon EKS creates
  # a Route 53 private hosted zone on your behalf and associates it with your
  # cluster's VPC. This private hosted zone is managed by Amazon EKS, and it doesn't
  # appear in your account's Route 53 resources. In order for the private hosted zone
  # to properly route traffic to your API server, your VPC must have enableDnsHostnames
  # and enableDnsSupport set to true
  # "
  # https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = var.allow_public_load_balancers ? {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  } : {}

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = local.tags
}
