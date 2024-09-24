terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "thema-11-tfstate"
    storage_account_name = "thema11sta"
    container_name       = "thema-11-tfstate"
    key                  = "terraform.tfstate"
  }
}


resource "azurerm_resource_group" "aks-rg" {
  name     = "thema-11-rg"
  location = "West Europe"
}


resource "azurerm_kubernetes_cluster" "thema11-aks" {
  name                = "thema11-aks"
  location            = "northeurope"
  resource_group_name = "thema-11-rg"
  dns_prefix          = "thema11-aks-dns"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                 = "agentpool"
    auto_scaling_enabled = true
    max_count            = 5
    min_count            = 2
    node_count           = 2
    vm_size              = "Standard_D4ds_v5"
    os_disk_type         = "Ephemeral"

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "custom" {
  name                  = "custom"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.thema11-aks.id
  vm_size               = "Standard_B2ms"

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    node_soak_duration_in_minutes = 0
  }
}
