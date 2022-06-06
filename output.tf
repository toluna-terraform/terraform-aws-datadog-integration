output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "account_alias" {
  value = data.aws_iam_account_alias.current.account_alias
}

output "name" {
  value = var.dd_site
}