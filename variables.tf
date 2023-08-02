#variable "resourcedetails" {
#  type = set(object({
#    name        = string
#    location    = string
#    size        = string
#    rg_name     = string
#    vnet_name   = string
#    subnet_name = string
##    data_disks  = optional(map(number))
#  }))
#  default = [
#    {
#      name        = "lp-800.azlhindp.dlh.de"
#      location    = "westeurope"
#      size        = "Standard_B2s"
#      rg_name     = "RG_LHIND_TEST"
#      vnet_name   = "VNET_DEVOPS4LHIND_P"
#      subnet_name = "SUB_LHIND_P_LINUX"
##      data_disks = {
##        "0" = 64
##        "1" = 300
##      }
#    },
#    {
#      name        = "lp-900.azlhindp.dlh.de",
#      location    = "westeurope",
#      size        = "Standard_B1s",
#      rg_name     = "RG_LHIND_TEST",
#      vnet_name   = "VNET_DEVOPS4LHIND_P",
#      subnet_name = "SUB_LHIND_P_LINUX",
##      data_disks = {
##        # "0" = 64,
##        # "1" = 150,
##      }
#    }
#  ]
#}



variable "resourcedetails" {
  type = map(object({
    name        = string
    location    = string
    size        = string
    rg_name     = string
    vnet_name   = string
    subnet_name = string
    data_disk   = list(number)
  }))
  default = {
    vm1 = {
      rg_name     = "RG__TEST"
      name        = "lp-800."
      location    = "westeurope"
      size        = "Standard_B2s"
      vnet_name   = "VNET_DEVOPS_P"
      subnet_name = "SUB__P_LINUX"
      data_disk   = [20, 30]
    }
    vm2 = {
      rg_name     = "RG_LHIND_TEST"
      name        = "lp-900"
      location    = "westeurope"
      size        = "Standard_B1s"
      vnet_name   = "VNET_DEVOPS_P"
      subnet_name = "SUB__P_LINUX"
      data_disk   = [40, 50]
    }
  }
}
