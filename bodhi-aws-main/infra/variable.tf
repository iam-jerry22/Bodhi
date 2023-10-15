variable "org_mail_domain" {
  description = "value of the email domain of organization"
}

variable "admin_user" {
  description = "value of the username of admin of organization"
}

variable "region" {
    description = "AWS region"
}

variable "cluster_name" {
  default = "bodhi-ask-test"
}

variable "env" {
  default = "prod"
}

variable "launch_template_name" {
  default = "stack-prod"
}

variable "secret_manager_secret_version" {
  description = "secret manager secret version"
}

variable "rds_db_name" {
  description = "RDS DB name"
  default     = "bodhicoreprodrds"
}

variable "rds_mysql_db_identifier" {
  default = "bodhicoreprodrds"
}

variable "route_53_hosted_zone_id" {
  description = "Route 53 hosted zone id"
}

variable "dns_zone" {
  default = "value of dns zone"
}

variable "aws_key_id" {
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
}

variable "aws_account_id" {
  description = "account number of aws user"
}


##### Keycloak Realm ########
variable "keycloak_realm_id" {
  default = "kubeflow"
}
variable "keycloak_realm" {
  default = "kubeflow"
}
variable "keycloak_realm_displayname" {
  default = "Bodhi"
}
variable "keycloak_email" {
  default = "manojkumar.dasi@publicissapient.com"
}
variable "keycloak_firstname" {
  default = "manoj"
}
variable "keycloak_lastname" {
  default = "dasi"
}
variable "keycloak_username" {
  default = "manoj-dasi"
}

variable "github_repo_link"{
  description = "code repo link"
}

variable "github_repo_branch"{
  description = "code repo branch"
}

variable "github_username"{
  description = "code repo username"
}

variable "github_password"{
  description = "code repo password"
}

variable "keycloak_dashboard_redirecturi" {
  default = "https://console.bodhimlops.xyz"
}
variable "keycloak_dashboard_callback_redirecturi" {
  default = "https://console.bodhimlops.xyz/oauth2/callback"
}

variable "superset_dashboard_rootUrl" {
  default = "https://superset.bodhimlops.xyz/"
}
variable "superset_dashboard_redirecturi" {
  default = "https://superset.bodhimlops.xyz/*"
}


#### EXTRA ######
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::412674115502:role/cluster-admin"
      username = "role1"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::412674115502:role/eks-minimal-user"
      username = "eks-minimal-user"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::412674115502:root"
      username = "root_user"
      groups   = ["system:bootstrappers", "system:nodes", "eks-console-dashboard-full-access-group"]
    },
    {

      userarn  = "arn:aws:iam::412674115502:user/pipeline-admin"
      username = "bodhi-admin"
      groups   = ["system:masters"]
    },
    {

      userarn  = "arn:aws:iam::412674115502:user/cluster-minimal-user"
      username = "bodhi-cluster-minimal-user"
      groups   = [ "system:nodes","eks-console-dashboard-full-access-group","system:bootstrappers"]
    }
    # {
    #   userarn  = "arn:aws:iam::66666666666:user/user2"
    #   username = "user2"
    #   groups   = ["system:masters"]
    # },
  ]
}


variable "oidc_thumbprint_list" {
  type    = list(any)
  default = []
}




