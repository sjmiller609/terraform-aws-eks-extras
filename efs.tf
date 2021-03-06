resource "aws_efs_file_system" "default" {
  count     = var.efs_enabled ? 1 : 0
  tags      = local.tags
  encrypted = true
}

resource "aws_efs_mount_target" "default" {
  count           = var.efs_enabled ? length(local.azs) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  subnet_id       = local.private_subnets[count.index]
  security_groups = [join("", aws_security_group.efs.*.id)]
}

resource "aws_security_group" "efs" {
  count       = var.efs_enabled ? 1 : 0
  name        = "${var.deployment_id}-efs"
  description = "EFS Security Group"
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "aws_security_group_rule" "ingress" {
  count                    = var.efs_enabled ? 1 : 0
  type                     = "ingress"
  from_port                = "2049" # NFS
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = module.eks.worker_security_group_id
  security_group_id        = join("", aws_security_group.efs.*.id)
}

resource "aws_security_group_rule" "egress" {
  count                    = var.efs_enabled ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks.worker_security_group_id
  security_group_id        = join("", aws_security_group.efs.*.id)
}

// resource "helm_release" "efs" {
//   name  = "aws-efs-csi-driver"
//   chart = "https://github.com/kubernetes-sigs/aws-efs-csi-driver/releases/download/v0.3.0/helm-chart.tgz"
// }

resource "helm_release" "efs" {
  name       = "efs-provisioner"
  chart      = "efs-provisioner"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  values = [<<EOF
---
efsProvisioner:
  awsRegion: ${local.region}
  efsFileSystemId: ${join("", aws_efs_file_system.default.*.id)}
EOF
  ]

}
