<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# AWS IAM ROLE
This module is designed to create an AWS IAM role. Currently this module, through the use of a 'feature flag', can be used to create the following:

* An IAM role for a user/group to assume _into_
* An IAM role to _be_ assumed into

This module allows you flexibility in how/what you attach policies to the IAM role based on what variables you set. See [USAGE](#usage) for examples.

## Usage

### Assume role set from file
```hcl
module "aws_iam_role" {
  source               = "git@github.com/lolcatlolcat/terraform-aws-iam/modules//iam-role?ref=v1.0.0"
  role_name            = "MyAmazingRole"
  description          = "My Terraform managed role"
  role_path            = "/TerraformAdminRoles/"
  policy_path          = "/TerraformAdminPolicies/"
  max_session_duration = 4500
  assume_role_policy   = jsonencode(file("assume.json"))
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSIoT1ClickReadOnlyAccess"
  ]
  tags = {
    Costcenter = "security"
    Environment = "prod"
  }

}
```

This example requires a JSON policy document such as:
```json
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::123456123456:root"
  }
}
```

### Assume role set programatically
```hcl
module "aws_iam_role" {
  source               = "git@github.com/lolcatlolcat/terraform-aws-iam/modules//iam-role?ref=v1.0.0"
  role_name            = "MyAmazingRole"
  description          = "My Terraform managed role"
  role_path            = "/TerraformAdminRoles/"
  policy_path          = "/TerraformAdminPolicies/"
  max_session_duration = 4500
  account_assuming     = 123456123456
  assuming_principal   = "role/AnotherRole"
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSIoT1ClickReadOnlyAccess"
  ]
  tags = {
    Costcenter = "security"
    Environment = "prod"
  }
}
```

This example results in the following policy document with the two policies defined in `policy_arn` attached:
```json
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::123456123456:role/Anotherrole"
  }
}
```

### Setting policy manually (using yaml as example)
```hcl
module "aws_iam_role" {
  source               = "git@github.com/lolcatlolcat/terraform-aws-iam/modules//iam-role?ref=v1.0.0"
  role_name            = "MyAmazingRole"
  description          = "My Terraform managed role"
  role_path            = "/TerraformAdminRoles/"
  policy_path          = "/TerraformAdminPolicies/"
  max_session_duration = 4500
  account_assuming     = 123456123456
  assuming_principal   = "role/AnotherRole"
  role_policies = [
    jsonencode(yamldecode(file("policy.yaml")))
  ]
  tags = {
    Costcenter = "security"
    Environment = "prod"
  }
}
```

For example, a policy defined in YAML syntax that provides all access:
```yaml
---
Version: '2012-10-17'
Statement:
- Sid: AdminAllowAll
  Action: "*"
  Effect: Allow
  Resource: "*"
```
Results in this policy statement attached to the role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AdminAllowAll",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_assuming"></a> [account_assuming](#input_account_assuming) | Account ID of the assumer for the IAM role assume role policy | `number` | n/a | yes |
| <a name="input_assume_role_policy"></a> [assume_role_policy](#input_assume_role_policy) | The assume role policy to apply if not using the generic sts:AssumeRole with a standard principal. | `string` | `null` | no |
| <a name="input_assuming_principal"></a> [assuming_principal](#input_assuming_principal) | The name of the principal to associate with the assume role policy. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Alternative to role_name if you want to use consistent var names across modules. | `string` | `null` | no |
| <a name="input_policy_arn"></a> [policy_arn](#input_policy_arn) | List of previously created or AWS managed policies ARNs to attach. This is exclusively used with the role_policies variable. | `list(string)` | `[]` | no |
| <a name="input_policy_path"></a> [policy_path](#input_policy_path) | Path to store the policy under. | `string` | `"/TerraformManagedPolicies/"` | no |
| <a name="input_role_description"></a> [role_description](#input_role_description) | Meaninful description to provide the role. | `string` | `"Terraform Managed Role"` | no |
| <a name="input_role_duration"></a> [role_duration](#input_role_duration) | Length (in seconds) to keep role session authenticated. | `number` | `3600` | no |
| <a name="input_role_name"></a> [role_name](#input_role_name) | The name of the role. | `string` | n/a | yes |
| <a name="input_role_path"></a> [role_path](#input_role_path) | Path to store the role under. | `string` | `"/TerraformManagedRoles/"` | no |
| <a name="input_role_perms_boundary"></a> [role_perms_boundary](#input_role_perms_boundary) | IAM permissions boundary to apply if applicable. | `string` | `null` | no |
| <a name="input_role_policies"></a> [role_policies](#input_role_policies) | Custom JSON formatted policy to be attached to role | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to apply to resource and components created. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_policy_arn"></a> [iam_policy_arn](#output_iam_policy_arn) | The ARN assigned by AWS to this policy. |
| <a name="output_iam_policy_description"></a> [iam_policy_description](#output_iam_policy_description) | The description of the policy. |
| <a name="output_iam_policy_name"></a> [iam_policy_name](#output_iam_policy_name) | The name of the policy. |
| <a name="output_iam_policy_policy-id"></a> [iam_policy_policy-id](#output_iam_policy_policy-id) | The policy's ID. |
| <a name="output_iam_policy_tags"></a> [iam_policy_tags](#output_iam_policy_tags) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block. |
| <a name="output_iam_role_arn"></a> [iam_role_arn](#output_iam_role_arn) | Amazon Resource Name (ARN) specifying the role. |
| <a name="output_iam_role_id"></a> [iam_role_id](#output_iam_role_id) | Name of the role. |
| <a name="output_iam_role_name"></a> [iam_role_name](#output_iam_role_name) | Name of the role. |
| <a name="output_iam_role_tags"></a> [iam_role_tags](#output_iam_role_tags) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block. |

 ## Contribution
  Branch off main, open a PR! All are welcome!

  When youre ready to create a new release, just do the following:
  1. `git describe --tags --abbrev=0`
  2. Increment your version +1
  3. `git tag v$VERSION && git push origin v$VERSION`

  This file `README.md` is maintained by [terraform-docs](https://terraform-docs.io/), changes to this file may be overwritten.

  Additionally, this module relies on the following tools to be installed prior to committing any changes:
  * [terraform](https://www.terraform.io/) for `terraform fmt`
  * [tfsec](https://github.com/aquasecurity/tfsec) for security validation
  * [terraform-docs](https://terraform-docs.io/) for document generation
  * [pre-commit](https://pre-commit.com/)
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
