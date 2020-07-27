variable "deployment_id" {
  description = "A short, letters-only string to identify your deployment"
  type        = string
}

variable "allow_public_load_balancers" {
  description = "Should Kubernetes services be allow to create Load Balancers in public subnets?"
  default     = true
  type        = bool
}

variable "cluster_version" {
  description = "What Kubernetes Major.Minor version to use"
  default     = "1.16"
  type        = string
}

variable "tags" {
  description = "Tags to apply to as many resources as supported"
  default     = {}
  type        = map(string)
}

variable "spotinist_token" {
  type = string
}

variable "spotinist_account" {
  type = string
}

variable "efs_enabled" {
  type    = bool
  default = true
}

variable "velero_enabled" {
  type    = bool
  default = true
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "aws_account_id" {
  type = string
}

variable "enable_bastion" {
  type    = bool
  default = false
}

variable "local_path_provisioner_version" {
  type    = string
  default = "0.0.14"
}

