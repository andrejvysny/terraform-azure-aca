
locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = "AndrejVysny"
    app         = var.app
  }

}

resource "azurerm_resource_group" "snapshare-resource" {
  name     = "rg-${local.stack}"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "snapshare-logs" {
  name                = "log-${local.stack}"
  location            = azurerm_resource_group.snapshare-resource.location
  resource_group_name = azurerm_resource_group.snapshare-resource.name
  tags = local.default_tags
}



resource "azurerm_container_app_environment" "snapshare-cae" {
  name                       = "cae-${local.stack}"
  location                   = azurerm_resource_group.snapshare-resource.location
  resource_group_name        = azurerm_resource_group.snapshare-resource.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.snapshare-logs.id

  tags = local.default_tags
}

resource "azurerm_container_app" "snapshare-container-app" {
  name = "testca-${local.stack}"
  container_app_environment_id = azurerm_container_app_environment.snapshare-cae.id
  resource_group_name          = azurerm_resource_group.snapshare-resource.name
  revision_mode                = "Single"

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage = 100
    }


  }

  template {
    revision_suffix = "learn"
    max_replicas = 2
    min_replicas = 1
    container {
      name   = "ca-${var.env}"
      image  = "ghcr.io/andrejvysny/nginx-hello-world:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
  tags = local.default_tags
}