resource "kubernetes_namespace" "velero" {
  count = var.velero_enabled ? 1: 0
  metadata {
    name = "velero"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  count = var.velero_enabled ? 1: 0
  bucket = "${var.deployment_id}-s3-bucket-logs"
  acl    = "log-delivery-write"
  lifecycle_rule {
    id      = "${var.deployment_id}-velero-backups-log-lifecycle-rule"
    enabled = true
    prefix = "${var.deployment_id}-velero-backups-log/"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket" "velero-backups" {
  count  = var.velero_enabled ? 1 : 0
  bucket = "${var.deployment_id}-velero-backups"
  acl    = "private"
  logging {
    target_bucket = aws_s3_bucket.log_bucket.0.id
    target_prefix = "${var.deployment_id}-velero-backups-log/"
  }
  lifecycle_rule {
    id      = "${var.deployment_id}-velero-backups"
    enabled = true
    prefix = "${var.deployment_id}-velero-backups/"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }
}

resource "aws_iam_policy" "velero_pod_bucket_access_policy" {
  count = var.velero_enabled ? 1: 0
  name        = "${var.deployment_id}_velero_pod_bucket_access_policy"
  path        = "/"
  description = "A policy that allows access for the Velero server to the backup bucket"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ec2:AttachVolume",
            "ec2:CopySnapshot",
            "ec2:DescribeVolumeAttribute",
            "ec2:DescribeVolumesModifications",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume",
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot",
            "ec2:ImportSnapshot",
            "ec2:CreateTags"
        ],
        "Resource": [
            "*"
        ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.velero-backups.0.arn}",
        "${aws_s3_bucket.velero-backups.0.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "velero_policy_attachment" {
  count = var.velero_enabled ? 1: 0
  role       = aws_iam_role.velero_role.0.name
  policy_arn = aws_iam_policy.velero_pod_bucket_access_policy.0.arn
}

resource "aws_iam_role" "velero_role" {
  count = var.velero_enabled ? 1: 0
  name = "${var.deployment_id}_velero_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${local.oidc_provider}:sub": "system:serviceaccount:${kubernetes_namespace.velero.0.metadata.0.name}:velero-service-account"
        }
      }
    }
  ]
}
EOF
}

resource "helm_release" "velero" {
  count      = var.velero_enabled ? 1 : 0
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "2.12.0"
  namespace  = kubernetes_namespace.velero.0.metadata.0.name
  timeout    = 1200

  values = [<<EOF
---
image:
  repository: velero/velero
  tag: v1.4.2

initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.1.0
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins

metrics:
  enabled: true
  scrapeInterval: 30s
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8085"
    prometheus.io/path: "/metrics"
  serviceMonitor:
    enabled: false
    additionalLabels: {}

installCRDs: true

# Necessary for allowing the IAM role use
securityContext:
  runAsUser: 0

configuration:
  provider: aws
  backupStorageLocation:
    name: default
    bucket: "${aws_s3_bucket.velero-backups.0.bucket}"
    prefix: "${var.deployment_id}-velero-backups/"
    # prefix: "${var.deployment_id}-velero-backups-log/"
    config:
      region: "${var.aws_region}"

  volumeSnapshotLocation:
    name: default
    config:
      region: "${var.aws_region}"

  backupSyncPeriod: 1m
  resticTimeout: 1h
  restoreResourcePriorities: namespaces,persistentvolumes,persistentvolumeclaims,secrets,configmaps,serviceaccounts,limitranges,pods
  restoreOnlyMode: false
  logLevel: info
  logFormat: text

rbac:
  create: true
  clusterAdministrator: true

# IAM provided through IAM role to K8s service account mapping
credentials:
  useSecret: false
serviceAccount:
  server:
    create: true
    name: velero-service-account
    annotations:
      "eks.amazonaws.com/role-arn": "${aws_iam_role.velero_role.0.arn}"

backupsEnabled: true
snapshotsEnabled: true

# Whether to deploy the restic daemonset.
# This is the component that backs up
# persistent volumes.
deployRestic: true

schedules:
  minute:
    schedule: "0 * * * *"
    template:
      ttl: "1h"
      includedNamespaces:
       - "*"
  hour:
    schedule: "0 0 * * *"
    template:
      ttl: "720h"
      includedNamespaces:
       - "*"
EOF
  ]
}
