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
