terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_network_interface" "mynic" {
  for_each = var.resourcedetails

  name                = "${each.value.name}-NIC"
  location            = each.value.location
  resource_group_name = each.value.rg_name
  ip_configuration {
    name                          = "${each.key}-NIC"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "main" {
  for_each                        = var.resourcedetails
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.rg_name
  network_interface_ids           = [azurerm_network_interface.mynic[each.key].id]
  size                            = each.value.size
  disable_password_authentication = true
  source_image_id                 = data.azurerm_shared_image.image.id
  admin_username                  = "lhsys"

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 64
    storage_account_type = "Premium_LRS"
  }
  admin_ssh_key {
    username   = "lhsys"
    public_key = "ssh-rsa AAAAB3NzaC1yc2Ephz28TLtvVJp+c4RveCUJr4Y3c8K4qOy0TQ28UvgogH7jv"
  }
}

locals {
  vm_datadiskdisk_count_map = {
    for k in toset(var.resourcedetails) : k => var.nb_disks_per_instance
  }
  luns = {
    for k in local.datadisk_lun_map : k.datadisk_name => k.lun
  }
  datadisk_lun_map = flatten([
    for vm_name, count in local.vm_datadiskdisk_count_map : [
      for i in range(count) : {
        datadisk_name = format("%s_Data_Disk_%02d", vm_name, i)
        lun           = i
      }
    ]
  ])
}


#resource "azurerm_managed_disk" "data" {
#  for_each             = var.resourcedetails
#  name                 = "${each.value.name}-DataDisk"
#  location             = each.value.location
#  resource_group_name  = each.value.rg_name
#  storage_account_type = "Premium_LRS"
#  create_option        = "Empty"
#  disk_size_gb = each.value.data_disk
#}

#resource "azurerm_managed_disk" "data" {
#  for_each = var.resourcedetails
#
#  dynamic "data_disk" {
#    for_each = each.value.data_disk
#
#    content {
#      name                 = "${data_disk.value}-${each.key}"
#      location             = each.value.location
#      resource_group_name  = each.value.rg_name
#      storage_account_type = "Premium_LRS"
#      create_option        = "Empty"
#      disk_size_gb         = data_disk.value
#    }
#  }
#  create_option        = "Empty"
#  location             = each.value.location
#  name                 = "${data_disk.key}-${each.key}"
#  resource_group_name  = each.value.rg_name
#  storage_account_type = "Premium_LRS"
#}
#









#resource "azurerm_virtual_machine_data_disk_attachment" "data" {
#  for_each           = var.resourcedetails
#  managed_disk_id    = azurerm_managed_disk.data[each.key].id
#  virtual_machine_id = azurerm_linux_virtual_machine.main[each.key].id
#  lun                = each.key
#  caching            = "ReadWrite"
#}