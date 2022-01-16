output "iam_role_arn" {
  value       = aws_iam_role.role.arn
  description = "Amazon Resource Name (ARN) specifying the role."
}

output "iam_role_name" {
  value       = aws_iam_role.role.name
  description = "Name of the role."
}

output "iam_role_id" {
  value       = aws_iam_role.role.id
  description = "Name of the role."
}

output "iam_role_tags" {
  value       = aws_iam_role.role.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

output "iam_policy_arn" {
  value = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.arn
  }
  description = "The ARN assigned by AWS to this policy."
}

output "iam_policy_name" {
  value = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.name
  }
  description = "The name of the policy."
}

output "iam_policy_tags" {
  value = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.tags_all
  }
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

output "iam_policy_description" {
  value = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.description
  }
  description = "The description of the policy."
}

output "iam_policy_policy-id" {
  value = {
    for k, v in aws_iam_policy.managed_policy_create : k => v.id
  }
  description = "The policy's ID."
}
