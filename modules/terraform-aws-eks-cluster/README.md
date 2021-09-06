
<!-- markdownlint-disable -->
# terraform-aws-eks-cluster [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-eks-cluster.svg)](https://github.com/cloudposse/terraform-aws-eks-cluster/releases/latest)
<!-- markdownlint-restore -->


## Introduction

The module provisions the following resources:

- EKS cluster of master nodes that can be used together with the [terraform-aws-eks-node-group](https://github.com/cloudposse/terraform-aws-eks-node-group) modules to create a full-blown cluster
- IAM Role to allow the cluster to access other AWS services
- Security Group which is used by EKS workers to connect to the cluster and kubelets and pods to receive communication from the cluster control plane
- The module creates and automatically applies an authentication ConfigMap to allow the workers nodes to join the cluster and to add additional users/roles/accounts

__NOTE:__ The module works with [Terraform Cloud](https://www.terraform.io/docs/cloud/index.html).

__NOTE:__ In `auth.tf`, we added `ignore_changes = [data["mapRoles"]]` to the `kubernetes_config_map` for the following reason:
- We provision the EKS cluster and then the Kubernetes Auth ConfigMap to map additional roles/users/accounts to Kubernetes groups
- Then we wait for the cluster to become available and for the ConfigMap to get provisioned (see `data "null_data_source" "wait_for_cluster_and_kubernetes_configmap"` in `examples/complete/main.tf`)
- Then we provision a managed Node Group
- Then EKS updates the Auth ConfigMap and adds worker roles to it (for the worker nodes to join the cluster)
- Since the ConfigMap is modified outside of Terraform state, Terraform wants to update it (remove the roles that EKS added) on each `plan/apply`

If you want to modify the Node Group (e.g. add more Node Groups to the cluster) or need to map other IAM roles to Kubernetes groups,
set the variable `kubernetes_config_map_ignore_role_changes` to `false` and re-provision the module. Then set `kubernetes_config_map_ignore_role_changes` back to `true`.



## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.



For a complete example, see [examples/complete](examples/complete).

For automated tests of the complete example using [bats](https://github.com/bats-core/bats-core) and [Terratest](https://github.com/gruntwork-io/terratest) (which tests and deploys the example on AWS), see [test](test).

Other examples:

- [terraform-root-modules/eks](https://github.com/cloudposse/terraform-root-modules/tree/master/aws/eks) - Cloud Posse's service catalog of "root module" invocations for provisioning reference architectures
- [terraform-root-modules/eks-backing-services-peering](https://github.com/cloudposse/terraform-root-modules/tree/master/aws/eks-backing-services-peering) - example of VPC peering between the EKS VPC and backing services VPC

```hcl
provider "aws" {
  region = var.region
}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  namespace = "eks"
  name      = "solfacil"
  stage     = "stg"
  delimiter = "-"
  #attributes = ""
  #tags       = var.tags
}

locals {
  tags = merge(var.tags, map("kubernetes.io/cluster/${module.label.id}", "shared"))

  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
}

module "eks_cluster" {
  source                    = "git::https://github.com/alysonfranklin/terraform-modules.git//modules/terraform-aws-eks-cluster?ref=0.41.0"
  namespace                 = "solfacil"
  stage                     = "stg"
  name                      = "eks"
  label_order               = ["name", "namespace", "stage", "attributes"]
  tags                      = var.tags
  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  region                    = var.region
  enabled_cluster_log_types = var.enabled_cluster_log_types
  public_access_cidrs       = var.public_access_cidrs
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access

  kubernetes_version                                        = var.kubernetes_version
  apply_config_map_aws_auth                                 = var.apply_config_map_aws_auth
  cluster_encryption_config_enabled                         = true
  cluster_log_retention_period                              = 30
  cluster_encryption_config_kms_key_enable_key_rotation     = true
  cluster_encryption_config_kms_key_deletion_window_in_days = 7
  oidc_provider_enabled                                     = var.oidc_provider_enabled
  kubernetes_config_map_ignore_role_changes                 = true // Defina como true para ignorar as alterações de papel do IAM no Kubernetes Auth ConfigMap
  map_additional_iam_users = [
    {
      userarn  = "arn:aws:iam::ACCOUNT_ID:user/alyson.franklin"
      username = "alyson.franklin"
      groups   = ["system:masters"]
    }
  ]
  map_additional_iam_roles = [
    {
      rolearn  = "arn:aws:iam::ACCOUNT_ID:role/JenkinsRoleForTerraform"
      username = "JenkinsRoleForTerraform"
      groups   = ["system:masters"]
    }
  ]
  #workers_role_arns     = [module.eks_workers.workers_role_arn]

  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["3.xx.x.x./32"] # IP da VPN
      source_security_group_id = null
      description              = "Allow all inbound traffic from EKS workers Security Group"
    }
  ]
}
```

Module usage with two worker groups:

```hcl
provider "aws" {
  region = var.region
}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  namespace = "eks"
  name      = "solfacil"
  stage     = "stg"
  delimiter = "-"
  #attributes = ""
  #tags       = var.tags
}

locals {
  tags = merge(var.tags, map("kubernetes.io/cluster/${module.label.id}", "shared"))

  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
}

module "eks_cluster" {
  source                    = "git::https://github.com/alysonfranklin/terraform-modules.git//modules/terraform-aws-eks-cluster?ref=0.41.0"
  namespace                 = "solfacil"
  stage                     = "stg"
  name                      = "eks"
  label_order               = ["name", "namespace", "stage", "attributes"]
  tags                      = var.tags
  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  region                    = var.region
  enabled_cluster_log_types = var.enabled_cluster_log_types
  public_access_cidrs       = var.public_access_cidrs
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access

  kubernetes_version                                        = var.kubernetes_version
  apply_config_map_aws_auth                                 = var.apply_config_map_aws_auth
  cluster_encryption_config_enabled                         = true
  cluster_log_retention_period                              = 30
  cluster_encryption_config_kms_key_enable_key_rotation     = true
  cluster_encryption_config_kms_key_deletion_window_in_days = 7
  oidc_provider_enabled                                     = var.oidc_provider_enabled
  kubernetes_config_map_ignore_role_changes                 = true // Defina como true para ignorar as alterações de papel do IAM no Kubernetes Auth ConfigMap
  map_additional_iam_users = [
    {
      userarn  = "arn:aws:iam::ACCOUNT_ID:user/alyson.franklin"
      username = "alyson.franklin"
      groups   = ["system:masters"]
    }
  ]
  map_additional_iam_roles = [
    {
      rolearn  = "arn:aws:iam::ACCOUNT_ID:role/JenkinsRoleForTerraform"
      username = "JenkinsRoleForTerraform"
      groups   = ["system:masters"]
    }
  ]
  #workers_role_arns     = [module.eks_workers.workers_role_arn]

  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["3.xx.x.x./32"] # IP da VPN
      source_security_group_id = null
      description              = "Allow all inbound traffic from EKS workers Security Group"
    }
  ]
}

module "eks_node_group" {
  source                    = "git::https://github.com/alysonfranklin/terraform-modules.git//modules/terraform-aws-eks-node-group?ref=0.21.0"
  namespace                               = "solfacil"
  name                                    = "eks"
  stage                                   = "stg"
  tags                                    = var.tags
  subnet_ids                              = var.subnet_ids
  instance_types                          = var.instance_types
  desired_size                            = 8
  min_size                                = 0
  max_size                                = 30
  cluster_name                            = var.cluster_name
  kubernetes_version                      = var.kubernetes_version
  capacity_type                           = "SPOT" # ON_DEMAND
  metadata_http_endpoint                  = "enabled"
  cluster_autoscaler_enabled              = true
  create_before_destroy                   = true
  disk_size                               = 20
  disk_type                               = "gp3"
  existing_workers_role_policy_arns       = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  label_order                             = ["name", "namespace", "stage", "attributes"]
  launch_template_disk_encryption_enabled = true
  # kubelet_additional_options              = "--max-pods=100"
  resources_to_tag                        = ["instance", "volume", "elastic-gpu", "spot-instances-request"]
  kubernetes_labels                       = { "workload-type" : "traefik" } // Apenas nós com esse rótulo serão adicionados ao NLB
  # before_cluster_joining_userdata       = local.bottlerocket_userdata
  # after_cluster_joining_userdata        = "" # https://kubedex.com/90-days-of-aws-eks-in-production
  # ami_image_id                          = "ami-0a703271661f18745" # AMI para usar no nodegroup - ignora a AMI do Launch Template
  # service.beta.kubernetes.io/aws-load-balancer-target-node-labels: workload-type=traefik
  # kubernetes_taints       = ""
  # launch_template_name    = ""
  # launch_template_version = ""
  ec2_ssh_key           = "solfacil-staging" // KeyPar existente na AWS
  remote_access_enabled = true               // Habilita SSH nos Workers
  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["3.x.1xx.x/32"] # IP da VPN
      source_security_group_id = null
      description              = "Allow all inbound traffic from VPN"
    }
  ]
}
```





## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | cloudposse/security-group/aws | 0.3.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cluster_elb_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.aws_auth_ignore_changes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [null_resource.wait_for_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_elb_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [tls_certificate.cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_apply_config_map_aws_auth"></a> [apply\_config\_map\_aws\_auth](#input\_apply\_config\_map\_aws\_auth) | Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_cluster_encryption_config_enabled"></a> [cluster\_encryption\_config\_enabled](#input\_cluster\_encryption\_config\_enabled) | Set to `true` to enable Cluster Encryption Configuration | `bool` | `true` | no |
| <a name="input_cluster_encryption_config_kms_key_deletion_window_in_days"></a> [cluster\_encryption\_config\_kms\_key\_deletion\_window\_in\_days](#input\_cluster\_encryption\_config\_kms\_key\_deletion\_window\_in\_days) | Cluster Encryption Config KMS Key Resource argument - key deletion windows in days post destruction | `number` | `10` | no |
| <a name="input_cluster_encryption_config_kms_key_enable_key_rotation"></a> [cluster\_encryption\_config\_kms\_key\_enable\_key\_rotation](#input\_cluster\_encryption\_config\_kms\_key\_enable\_key\_rotation) | Cluster Encryption Config KMS Key Resource argument - enable kms key rotation | `bool` | `true` | no |
| <a name="input_cluster_encryption_config_kms_key_id"></a> [cluster\_encryption\_config\_kms\_key\_id](#input\_cluster\_encryption\_config\_kms\_key\_id) | KMS Key ID to use for cluster encryption config | `string` | `""` | no |
| <a name="input_cluster_encryption_config_kms_key_policy"></a> [cluster\_encryption\_config\_kms\_key\_policy](#input\_cluster\_encryption\_config\_kms\_key\_policy) | Cluster Encryption Config KMS Key Resource argument - key policy | `string` | `null` | no |
| <a name="input_cluster_encryption_config_resources"></a> [cluster\_encryption\_config\_resources](#input\_cluster\_encryption\_config\_resources) | Cluster Encryption Config Resources to encrypt, e.g. ['secrets'] | `list(any)` | <pre>[<br>  "secrets"<br>]</pre> | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | `number` | `0` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_eks_cluster_service_role_arn"></a> [eks\_cluster\_service\_role\_arn](#input\_eks\_cluster\_service\_role\_arn) | The ARN of an externally created EKS service role to use, or leave blank to create one | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | `[]` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_kubernetes_config_map_ignore_role_changes"></a> [kubernetes\_config\_map\_ignore\_role\_changes](#input\_kubernetes\_config\_map\_ignore\_role\_changes) | Set to `true` to ignore IAM role changes in the Kubernetes Auth ConfigMap | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `"1.15"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_local_exec_interpreter"></a> [local\_exec\_interpreter](#input\_local\_exec\_interpreter) | shell to use for local\_exec | `list(string)` | <pre>[<br>  "/bin/sh",<br>  "-c"<br>]</pre> | no |
| <a name="input_map_additional_aws_accounts"></a> [map\_additional\_aws\_accounts](#input\_map\_additional\_aws\_accounts) | Additional AWS account numbers to add to `config-map-aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_map_additional_iam_roles"></a> [map\_additional\_iam\_roles](#input\_map\_additional\_iam\_roles) | Additional IAM roles to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_additional_iam_users"></a> [map\_additional\_iam\_users](#input\_map\_additional\_iam\_users) | Additional IAM users to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_oidc_provider_enabled"></a> [oidc\_provider\_enabled](#input\_oidc\_provider\_enabled) | Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html | `bool` | `false` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | `null` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | The Security Group description. | `string` | `"Security Group for EKS cluster"` | no |
| <a name="input_security_group_enabled"></a> [security\_group\_enabled](#input\_security\_group\_enabled) | Whether to create default Security Group for EKS cluster. | `bool` | `true` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow all outbound traffic",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 65535,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_security_group_use_name_prefix"></a> [security\_group\_use\_name\_prefix](#input\_security\_group\_use\_name\_prefix) | Whether to create a default Security Group with unique name beginning with the normalized prefix. | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of Security Group IDs to associate with EKS cluster. | `list(string)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs to launch the cluster in | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the EKS cluster | `string` | n/a | yes |
| <a name="input_wait_for_cluster_command"></a> [wait\_for\_cluster\_command](#input\_wait\_for\_cluster\_command) | `local-exec` command to execute to determine if the EKS cluster is healthy. Cluster endpoint are available as environment variable `ENDPOINT` | `string` | `"curl --silent --fail --retry 60 --retry-delay 5 --retry-connrefused --insecure --output /dev/null $ENDPOINT/healthz"` | no |
| <a name="input_workers_role_arns"></a> [workers\_role\_arns](#input\_workers\_role\_arns) | List of Role ARNs of the worker nodes | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_encryption_config_enabled"></a> [cluster\_encryption\_config\_enabled](#output\_cluster\_encryption\_config\_enabled) | If true, Cluster Encryption Configuration is enabled |
| <a name="output_cluster_encryption_config_provider_key_alias"></a> [cluster\_encryption\_config\_provider\_key\_alias](#output\_cluster\_encryption\_config\_provider\_key\_alias) | Cluster Encryption Config KMS Key Alias ARN |
| <a name="output_cluster_encryption_config_provider_key_arn"></a> [cluster\_encryption\_config\_provider\_key\_arn](#output\_cluster\_encryption\_config\_provider\_key\_arn) | Cluster Encryption Config KMS Key ARN |
| <a name="output_cluster_encryption_config_resources"></a> [cluster\_encryption\_config\_resources](#output\_cluster\_encryption\_config\_resources) | Cluster Encryption Config Resources |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | The Kubernetes cluster certificate authority data |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint for the Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the cluster |
| <a name="output_eks_cluster_identity_oidc_issuer"></a> [eks\_cluster\_identity\_oidc\_issuer](#output\_eks\_cluster\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster |
| <a name="output_eks_cluster_identity_oidc_issuer_arn"></a> [eks\_cluster\_identity\_oidc\_issuer\_arn](#output\_eks\_cluster\_identity\_oidc\_issuer\_arn) | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account |
| <a name="output_eks_cluster_managed_security_group_id"></a> [eks\_cluster\_managed\_security\_group\_id](#output\_eks\_cluster\_managed\_security\_group\_id) | Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads |
| <a name="output_eks_cluster_role_arn"></a> [eks\_cluster\_role\_arn](#output\_eks\_cluster\_role\_arn) | ARN of the EKS cluster IAM role |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | The Kubernetes server version of the cluster |
| <a name="output_kubernetes_config_map_id"></a> [kubernetes\_config\_map\_id](#output\_kubernetes\_config\_map\_id) | ID of `aws-auth` Kubernetes ConfigMap |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the EKS cluster Security Group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the EKS cluster Security Group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the EKS cluster Security Group |
<!-- markdownlint-restore -->


