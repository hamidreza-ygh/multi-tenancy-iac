variable "vue_app_base_url" {
  description = "The base URL of the Vue app"
  type = string
  default = "http://localhost:3003/"
}

variable "vue_app_user_api_url" {
  description = "The URL of the Vue app user management API"
  type = string
  # default = "http://tenant-manager.control-tier.svc"
  default = "http://api.tenantodo.life"
}

variable "vue_app_tenant_provision_url" {
  description = "The URL of the Vue app tenant provisioning API"
  type = string
  default = "https://api.github.com/repos/hamidreza-ygh/tenant-provision/actions/workflows/provision.yml/dispatches"
  sensitive = true 
}

variable "vue_app_gh_token" {
  description = "The GitHub token for the Tenant Provision Dispatchtrigger"
  type = string
  default = ""
  sensitive = true 
}

variable "me_config_mongodb_url" {
  description = "The MongoDB URL for the ME Config API"
  type = string
  default = "mongodb://localhost:27017/users"
}

variable "jwt_secret" {
  description = "The GitHub token for the Tenant Provision Dispatchtrigger"
  type = string
  default = ""
  sensitive = true 
}