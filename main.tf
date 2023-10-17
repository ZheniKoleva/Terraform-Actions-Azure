terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "taskboardstoragezh"
    container_name       = "task-board-container"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

resource "random_integer" "integer" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}${random_integer.integer.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = "${var.app_service_name}${random_integer.integer.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_database_name};User ID=${var.sql_administrator_login};Password=${var.sql_administrator_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.sql_server_name}${random_integer.integer.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_password
}

resource "azurerm_mssql_database" "database" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "sql_firewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id                 = azurerm_linux_web_app.linux_web_app.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}
