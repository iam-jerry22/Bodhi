output "_cluster_name_bodhi" {
  value = var.cluster_name
}

output "_region_bodhi"{
    value = var.region
}

output "_email_domain_certmanager_bodhi"{
    value = var.org_mail_domain
}

output "_email_user_bodhi"{
    value = var.admin_user
}

output "_aws_key_id" {
  value = var.aws_key_id
}

output "_aws_secret_access_key" {
  value = var.aws_secret_access_key
}

output "_aws_account_user_id" {
  value = var.aws_account_id
}

output "_vpc_ID" {
  value = module.vpc.vpc_id
}

output "_vpc_subnet_1" {
  value = module.vpc.public_subnets[0]
}
output "_vpc_subnet_2" {
  value = module.vpc.public_subnets[1]
}
output "_vpc_subnet_3" {
  value = module.vpc.public_subnets[2]
}
output "secret_key" {
  value = aws_iam_access_key.current.secret    # s3 secret key
  sensitive = true
}
output "access_key" {
  value = aws_iam_access_key.current.user   #s3 access key
}

output "route_53_hosted_zone_id" {
  value = var.route_53_hosted_zone_id
}

output "_domain_bodhi" {
  value       = var.dns_zone
}

output "_keycloak_realm_bodhi"{
    value = var.keycloak_realm
}

output "_github_repo_link"{
    value = var.github_repo_link
}

output "_github_repo_branch"{
    value = var.github_repo_branch
}

# output "_github_username"{
#     value = var.github_username
# }

# output "github_password"{
#     value = var.github_password
# }

output "_secret_manager_secret_version" {
  value = var.secret_manager_secret_version
}