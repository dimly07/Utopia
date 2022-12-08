resource "azurerm_resource_group" "consumer" {
  name     = "consumer"
  location = var.location
}
resource "azurerm_virtual_network" "consumer" {
  name                = "example-network"
  address_space       = ["10.255.255.0/24"]
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name
}
resource "azurerm_subnet" "consumer" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.consumer.name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = ["10.255.255.0/28"]
}
resource "azurerm_network_interface" "consumer" {
  name                = "consumervmnic"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.consumer.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "consumer" {
  name                            = "example-machine"
  resource_group_name             = azurerm_resource_group.consumer.name
  location                        = azurerm_resource_group.consumer.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.consumer.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
# resource "azurerm_network_security_group" "consumer_nsg" {
#   name                = "Consumer_NSG"
#   location            = azurerm_resource_group.consumer.location
#   resource_group_name = azurerm_resource_group.consumer.name

#   security_rule {
#     name                       = "Internet_In"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# resource "azurerm_subnet_network_security_group_association" "consumer_nsg" {
#   subnet_id                 = azurerm_subnet.consumer.id
#   network_security_group_id = azurerm_network_security_group.consumer_nsg.id
# }
## Configure the VM for nginx

# Add VNET peer to hub VNET via variable