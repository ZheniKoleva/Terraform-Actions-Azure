variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "Application service plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "Application name in Azure"
}

variable "sql_server_name" {
  type        = string
  description = "Name of the SQL server in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "Database name in Azure"
}

variable "sql_administrator_login" {
  type        = string
  description = "Database admin username in Azure"
}

variable "sql_administrator_password" {
  type        = string
  description = "Database admin password in Azure"
}

variable "firewall_rule_name" {
  type        = string
  description = "Firewall rule name in Azure"
}

variable "repo_URL" {
  type        = string
  description = "Repo URL in GitHub"
}

variable "resource_group_name_storage" {
  type        = string
  description = "Storage resource group name in Azure"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the storage container"
}