variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the gwlb virtual network"
}
variable "vnet_name" {
  type        = string
  description = "Name of the gwlb virtual network"
}
variable "management_subnet" {
  type        = list(string)
  description = "Address prefix for the management network"
}
variable "management_subnet_name" {
  type        = string
  description = "Name of Management Subnet"
}
# variable "data_subnet" {
#   type        = list(string)
#   description = "Address prefix for the data network"
# }
variable "trust_subnet" {
  type        = list(string)
  description = "Address prefix for the trust network"
}
variable "trust_subnet_name" {
  type        = string
  description = "Name of Trust Subnet"
}
variable "untrust_subnet" {
  type        = list(string)
  description = "Address prefix for the untrust network"
}
variable "untrust_subnet_name" {
  type        = string
  description = "Name of Untrust Subnet"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_prefixes
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "mgmt" {
  name                 = var.management_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.management_subnet
}
# resource "azurerm_subnet" "data" {
#   name                 = "data"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = var.data_subnet
# }
resource "azurerm_subnet" "trust" {
  name                 = var.trust_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.trust_subnet
}
resource "azurerm_subnet" "untrust" {
  name                 = var.untrust_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.untrust_subnet
}

resource "azurerm_network_security_group" "mgmt" {
  name                = "nsg-pafw-mgmt-usva-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_group" "untrust" {
  name                = "nsg-pafw-untrust-usva-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_group" "trust" {
  name                = "nsg-pafw-trust-usva-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}
resource "azurerm_subnet_network_security_group_association" "untrust" {
  subnet_id                 = azurerm_subnet.untrust.id
  network_security_group_id = azurerm_network_security_group.untrust.id
}
resource "azurerm_subnet_network_security_group_association" "trust" {
  subnet_id                 = azurerm_subnet.trust.id
  network_security_group_id = azurerm_network_security_group.trust.id
}
