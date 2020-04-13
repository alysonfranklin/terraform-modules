Terraform module for providing read and write access to the AWS SSM Parameter Store.

---

## Examples

This example creates a new `String` parameter called `/cp/prod/app/database/master_password` with the value of `password1`.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "ssm-parameter-store" {
  source = "github.com/alysonfranklin/terraform-modules.git//modules/ssm-parameter-store?ref=v0.0.1"
  parameter_write = [{
    name        = "/prod/databases/project-name"
    value       = "password!@#"
    type        = "SecureString"
    overwrite   = "true"
    description = "Production database master password"
  }]

  tags = {
    Terraform   = "true"
    Environment = "Prod"
    Project     = "DNE"
  }
}
```

### Simple Read Parameter Example

This example reads a value from the parameter store with the name `/cp/prod/app/database/master_password`

```hcl
module "store_read" {
  source         = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store?ref=master"
  parameter_read = ["/cp/prod/app/database/master_password"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Set to `false` to prevent the module from creating and accessing any resources | string | `true` | no |
| kms_arn | The ARN of a KMS key used to encrypt and decrypt SecretString values | string | `` | no |
| parameter_read | List of parameters to read from SSM. These must already exist otherwise an error is returned. Can be used with `parameter_write` as long as the parameters are different. | list | `<list>` | no |
| parameter_write | List of maps with the Parameter values in this format.   Parameter Write Format Example<br><br>  [{     name = "/cp/prod/app/database/master_password" // Required     type = "SecureString" // Required - Valid types are String, StringList and SecureString     value = "password1" // Required     description = "Production database master password" // Optional     overwrite = false // Optional - Force Overwrite of value if true.    }] | list | `<list>` | no |
| split_delimiter | A delimiter for splitting and joining lists together for normalising the output | string | `~^~` | no |
| tags | Map containing tags that will be added to the parameters | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| map | A map of the names and values created |
| names | A list of all of the parameter names |
| values | A list of all of the parameter values |

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://github.com/orgs/cloudposse/projects/3) with our other projects, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)

### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Jamie Nelson][Jamie-BitFlight_avatar]][Jamie-BitFlight_homepage]<br/>[Jamie Nelson][Jamie-BitFlight_homepage] |
|---|---|---|

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://github.com/osterman.png?size=150
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://github.com/aknysh.png?size=150
  [Jamie-BitFlight_homepage]: https://github.com/Jamie-BitFlight
  [Jamie-BitFlight_avatar]: https://github.com/Jamie-BitFlight.png?size=150
