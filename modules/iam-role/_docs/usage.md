```hcl
module "aws_iam_role" {
  source               = "git@gitlab.com:tfcode/tf-aws-iam-role.git?ref=v1.0.0"
  role_name            = "MyAmazingRole"
  description          = "My Terraform managed role"
  role_path            = "/TerraformAdminRoles/"
  policy_path          = "/TerraformAdminPolicies/"
  max_session_duration = 4500
  assuming_principal   = "root"
  
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
