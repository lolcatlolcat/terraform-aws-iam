# ---------------------------------------------------------------------------------------------------------------------
# CONVENIENCE VARIABLES AND DATA RESOURCES
# ---------------------------------------------------------------------------------------------------------------------
locals {
  iam_role_name = var.role_name != "" ? var.role_name : var.name
  role_policies = distinct(var.role_policies)
  role_policy_docs = {
    for policydoc in local.role_policies :
    index(local.role_policies, policydoc) => policydoc
  }
}

data "aws_caller_identity" "current" {}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "role" {
  name                 = local.iam_role_name
  description          = var.role_description
  assume_role_policy   = var.assume_role_policy == null ? data.aws_iam_policy_document.default_assume.json : var.assume_role_policy
  path                 = var.role_path
  max_session_duration = var.role_duration
  permissions_boundary = var.role_perms_boundary

  tags = merge(
    {
      "Name" : local.iam_role_name
    },
    var.tags,
  )
}

data "aws_iam_policy_document" "default_assume" {
  statement {
    effect = "Allow"
    sid    = "AllowAssume"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::${var.account_assuming}:%s", var.assuming_principal)
    }
  }
}

### Create policies
resource "aws_iam_policy" "managed_policy_create" {
  for_each    = local.role_policy_docs
  name        = format("${aws_iam_role.role.name}-RolePolicy-%02d", each.key)
  description = "Custom Policy for ${aws_iam_role.role.name}"
  policy      = each.value
  path        = var.policy_path
}

### Attach any created managed policies
resource "aws_iam_role_policy_attachment" "managed_policy_attach" {
  for_each = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.arn
    if length(var.policy_arn) == 0 && local.role_policy_docs != null
  }
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

### Attach policy ARNs directly
resource "aws_iam_role_policy_attachment" "policy_arn_attach" {
  for_each = {
    for arn in var.policy_arn : arn => arn
    if length(var.policy_arn) > 0 && local.role_policy_docs == null
  }
  role       = aws_iam_role.role.id
  policy_arn = each.value
}
