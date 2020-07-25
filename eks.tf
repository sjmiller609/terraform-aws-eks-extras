resource "tls_private_key" "worker-nodes" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "worker-nodes" {
  key_name   = "${var.deployment_id}-worker-nodes-keypair"
  public_key = tls_private_key.worker-nodes.public_key_openssh
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "helm" {
  # Helm version 3 provider is 1.*.*
  version = "~> 1.2"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    load_config_file       = false
  }
}

resource "aws_security_group" "allow_bastion" {
  name        = "${var.deployment_id}_allow_from_bastion"
  description = "Allow SSH traffic from bastion host"
  vpc_id      = local.vpc_id

  dynamic "ingress" {
    for_each = var.enable_bastion ? ["placeholder"] : []
    content {
      description     = "SSH ingress from bastion host"
      protocol        = "tcp"
      to_port         = 22
      from_port       = 22
      security_groups = [aws_security_group.bastion_sg.0.id]
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.1.0"

  cluster_name           = local.cluster_name
  cluster_version        = var.cluster_version
  cluster_create_timeout = "30m"

  # Enable IAM role to K8s service account mapping
  enable_irsa = true

  subnets = local.private_subnets

  vpc_id = local.vpc_id

  worker_groups = []
  # This worker group is used as a spec for
  # Ocean. We do not need to ever create an instance
  # in this group, so long as we set the minimum size
  # in Ocean to 1 or greater.
  worker_groups_launch_template = [
    {
      name                          = "launch-template-${local.cluster_name}"
      key_name                      = aws_key_pair.worker-nodes.key_name
      instance_type                 = "t2.small"
      additional_security_group_ids = [aws_security_group.allow_bastion.id]
      asg_desired_capacity          = 0
      asg_max_size                  = 0
      asg_min_size                  = 0
      public_ip                     = false
    }
  ]

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  manage_aws_auth = true

  tags = local.tags
}

resource "spotinst_ocean_aws" "cluster" {

  name          = local.cluster_name
  controller_id = local.cluster_name

  region = local.region

  # Free tier of Spot.io
  max_size = 10
  min_size = 1

  subnet_ids = local.private_subnets

  // --- LAUNCH CONFIGURATION --------------
  image_id                    = module.eks.workers_default_ami_id
  security_groups             = [module.eks.worker_security_group_id, aws_security_group.allow_bastion.id]
  user_data                   = local.user_data
  iam_instance_profile        = module.eks.worker_iam_instance_profile_names[0]
  root_volume_size            = 20
  monitoring                  = false
  ebs_optimized               = true
  associate_public_ip_address = false
  key_name                    = aws_key_pair.worker-nodes.key_name

  // --- STRATEGY --------------------
  fallback_to_ondemand       = true
  draining_timeout           = 120
  utilize_reserved_instances = false
  grace_period               = 600
  // ---------------------------------

  tags {
    key   = "kubernetes.io/cluster/${module.eks.cluster_id}"
    value = "owned"
  }
}


module "ocean-controller" {
  source  = "spotinst/ocean-controller/spotinst"
  version = "~> 0.2"

  cluster_identifier = local.cluster_name
  spotinst_token     = var.spotinist_token
  spotinst_account   = var.spotinist_account
}
