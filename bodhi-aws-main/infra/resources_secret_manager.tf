resource "aws_secretsmanager_secret" "bodhi_secrets" {
  name = "${var.cluster_name}/bodhi-${var.secret_manager_secret_version}/${var.env}"
}

resource "aws_secretsmanager_secret" "bodhi_repo_secrets" {
  name = "${var.cluster_name}/bodhi-${var.secret_manager_secret_version}/${var.env}-repo"
}

output "bodhi_repo_secret_manager_name" {
  value = aws_secretsmanager_secret.bodhi_repo_secrets.name
}
resource "random_password" "client_id" {
  length  = 16
  special = false
  lower   = true
}
resource "random_password" "client_secret" {
  length  = 32
  special = false
  lower   = true
}

resource "random_id" "cookie_secret" {
  byte_length = 16
}

resource "random_password" "admin_password" {
  length  = 16
  special = false
  lower   = true
}
resource "random_password" "database_password" {
  length  = 16
  special = false
  lower   = true
}
resource "random_password" "management_password" {
  length  = 16
  special = false
  lower   = true
}
resource "aws_secretsmanager_secret_version" "repo_secrets" {
  secret_id = aws_secretsmanager_secret.bodhi_repo_secrets.id
  secret_string = jsonencode({
    # HTTP UserName
    HTTPS_USERNAME = var.github_username
    HTTPS_PASSWORD = var.github_password
  })

}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.bodhi_secrets.id
  secret_string = jsonencode({
    ## RDS Access
    RDS_USERNAME = aws_db_instance.db.username,
    RDS_PASSWORD = aws_db_instance.db.password,

    #S3 Access 
    S3_ACCESSKEY = aws_iam_access_key.cluster_s3_access.id
    S3_SECRETKEY = aws_iam_access_key.cluster_s3_access.secret



    # OAUTH
    client-id     = random_password.client_id.result
    client-secret = random_password.client_secret.result
    cookie-secret = "${random_id.cookie_secret.b64_std}"

    # Admin User
    admin-user                   = "admin"
    admin-password               = random_password.admin_password.result
    database-password            = random_password.database_password.result
    postgresql-password          = random_password.database_password.result
    management-password          = random_password.management_password.result
    postgresql-postgres-password = random_password.database_password.result


    # keycloak realm 
    realm = "{\"id\":${jsonencode(var.keycloak_realm_id)},\"realm\":${jsonencode(var.keycloak_realm)},\"displayName\":${jsonencode(var.keycloak_realm_displayname)},\"enabled\":true,\"sslRequired\":\"external\",\"registrationAllowed\":false,\"requiredCredentials\":[\"password\"],\"users\":[{\"username\":${jsonencode(var.keycloak_username)},\"enabled\":true,\"email\":${jsonencode(var.keycloak_email)},\"firstName\":${jsonencode(var.keycloak_firstname)},\"lastName\":${jsonencode(var.keycloak_lastname)},\"credentials\":[{\"type\":\"password\",\"value\":${jsonencode(random_password.admin_password.result)}}],\"realmRoles\":[\"user\"],\"clientRoles\":{\"account\":[\"view-profile\",\"manage-account\"]}}],\"clients\":[{\"id\":\"56185130-63f4-441f-b618-f471e7baac6d\",\"clientId\":${jsonencode(random_password.client_id.result)},\"name\":\"Oauth2Proxy\",\"surrogateAuthRequired\":false,\"enabled\":true,\"alwaysDisplayInConsole\":false,\"clientAuthenticatorType\":\"client-secret\",\"secret\":${jsonencode(random_password.client_secret.result)},\"redirectUris\":[${jsonencode(var.keycloak_dashboard_redirecturi)},${jsonencode(var.keycloak_dashboard_callback_redirecturi)},\"*\"],\"webOrigins\":[]},{\"id\":\"efdd1c4b-cf32-4969-9ec8-3e0b2e0898cb\",\"clientId\":\"superset\",\"name\":\"superset\",\"description\":\"superset\",\"rootUrl\":${jsonencode(var.superset_dashboard_rootUrl)},\"surrogateAuthRequired\":false,\"enabled\":true,\"alwaysDisplayInConsole\":false,\"clientAuthenticatorType\":\"client-secret\",\"secret\":\"dd7f5869-5ea8-4f80-a945-583ddd25890c\",\"redirectUris\":[${jsonencode(var.superset_dashboard_redirecturi)},\"*\"],\"webOrigins\":[],\"notBefore\":0,\"bearerOnly\":false,\"consentRequired\":false,\"standardFlowEnabled\":true,\"implicitFlowEnabled\":false,\"directAccessGrantsEnabled\":true,\"serviceAccountsEnabled\":false,\"publicClient\":false,\"frontchannelLogout\":false,\"protocol\":\"openid-connect\",\"attributes\":{\"id.token.as.detached.signature\":\"false\",\"saml.assertion.signature\":\"false\",\"saml.force.post.binding\":\"false\",\"saml.multivalued.roles\":\"false\",\"saml.encrypt\":\"false\",\"oauth2.device.authorization.grant.enabled\":\"false\",\"backchannel.logout.revoke.offline.tokens\":\"false\",\"saml.server.signature\":\"false\",\"saml.server.signature.keyinfo.ext\":\"false\",\"use.refresh.tokens\":\"true\",\"exclude.session.state.from.auth.response\":\"false\",\"oidc.ciba.grant.enabled\":\"false\",\"saml.artifact.binding\":\"false\",\"backchannel.logout.session.required\":\"true\",\"client_credentials.use_refresh_token\":\"false\",\"saml_force_name_id_format\":\"false\",\"saml.client.signature\":\"false\",\"tls.client.certificate.bound.access.tokens\":\"false\",\"saml.authnstatement\":\"false\",\"display.on.consent.screen\":\"false\",\"saml.onetimeuse.condition\":\"false\"},\"authenticationFlowBindingOverrides\":{},\"fullScopeAllowed\":true,\"nodeReRegistrationTimeout\":-1,\"defaultClientScopes\":[\"web-origins\",\"profile\",\"roles\",\"email\"],\"optionalClientScopes\":[\"address\",\"phone\",\"offline_access\",\"microprofile-jwt\"]}]}"
  })
}


