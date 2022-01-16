# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed in by the templates using this module.
# ----------------------------------------------------------------------------------------------------------------------
variable "assuming_principal" {
  type        = string
  description = "The name of the principal to associate with the assume role policy."
  validation {
    condition     = can(regexall("^(root)|(user/[\\w]{1,64})|(group/[\\w+=,.@-]{1,128})|(role/[\\w+=,.@-]{1,64})$", var.assuming_principal))
    error_message = "Principal must be one of: root, role/Rolename, user/Username, group/Groupname."
  }
}

variable "role_name" {
  type        = string
  description = "The name of the role."
  validation {
    condition     = can(regexall("^(\\w+=,.@-]{1,64})$", var.role_name))
    error_message = "Name must be alphanumeric, less than 64 characters, and only contain these special characters: + = , . @ - ."
  }
}

variable "account_assuming" {
  type        = number
  description = "Account ID of the assumer for the IAM role assume role policy"
  validation {
    condition     = can(regexall("^[::digit::]{12}", var.account_assuming))
    error_message = "Account ID must be exactly 12 digits long."
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables may be optionally passed in by the templates using this module to overwite the defaults.
# ----------------------------------------------------------------------------------------------------------------------
variable "role_description" {
  type        = string
  description = "Meaninful description to provide the role."
  default     = "Terraform Managed Role"
}

variable "assume_role_policy" {
  type        = string
  description = "The assume role policy to apply if not using the generic sts:AssumeRole with a standard principal."
  default     = null
}

variable "role_path" {
  type        = string
  description = "Path to store the role under."
  default     = "/TerraformManagedRoles/"
}

variable "role_duration" {
  type        = number
  description = "Length (in seconds) to keep role session authenticated."
  default     = 3600
}

variable "role_perms_boundary" {
  type        = string
  description = "IAM permissions boundary to apply if applicable."
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to resource and components created."
  default     = {}
}

variable "policy_path" {
  type        = string
  description = "Path to store the policy under."
  default     = "/TerraformManagedPolicies/"
}

variable "policy_arn" {
  type        = list(string)
  default     = []
  description = "List of previously created or AWS managed policies ARNs to attach. This is exclusively used with the role_policies variable."
}

variable "name" {
  type        = string
  description = "Alternative to role_name if you want to use consistent var names across modules."
  default     = null
  validation {
    condition = (
      var.name == null ||
      can(regex("^(\\w+=,.@-]{1,64})+$", var.name))
    )
    error_message = "Name must be alphanumeric, less than 64 characters, and only contain these special characters: + = , . @ - ."
  }
}

variable "role_policies" {
  type        = list(string)
  description = "Custom JSON formatted policy to be attached to role"
  default     = []
}
