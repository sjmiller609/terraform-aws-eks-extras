resource "random_string" "suffix" {
  length  = 8
  special = false
}

data "aws_region" "current" {}

locals {
  cluster_name = "${var.deployment_id}-${random_string.suffix.result}"

  region = data.aws_region.current.name
  azs    = ["${local.region}a", "${local.region}b", "${local.region}c"]

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  oidc_provider = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  tags = merge(
    var.tags,
    map(
      "DEPLOYMENT_ID", var.deployment_id
    )
  )

  user_data = base64encode(<<EOT
#!/bin/bash -xe

${file("${path.module}/setup-disks.sh")}

/etc/eks/bootstrap.sh --b64-cluster-ca '${module.eks.cluster_certificate_authority_data}' --apiserver-endpoint '${module.eks.cluster_endpoint}' --kubelet-extra-args "" '${local.cluster_name}'
EOT
  )

}
