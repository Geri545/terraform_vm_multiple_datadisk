#data "azurerm_resource_group" "resource_group" {
#  for_each = var.resourcedetails
#  name     = "RG_LHIND_TEST"
#}

data "azurerm_virtual_network" "virtual_network" {
  name                = "VNET_DEVOPS4LHIND_P"
  resource_group_name = "RG_LHIND_AMS_DEVOPS4LHIND_VNET_DEVOPS4LHIND_P"
}

data "azurerm_subnet" "subnet" {
  name                 = "SUB_LHIND_P_LINUX"
  resource_group_name  = data.azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
}


data "azurerm_shared_image" "image" {
  gallery_name        = "LHINDTemplateVMs"
  resource_group_name = "RG_LHIND_AMS_DEVOPS4LHT_TEMPLATE_VM_DEVOPS4LHIND_P"
  name                = "RHEL8.7"
}

provider "azurerm" {
  subscription_id = "54bad382-a2ed-4a22-bf45-c04a8a9a4df4"
  alias           = "prod"
  features {}
}