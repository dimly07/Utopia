resource "azurerm_public_ip" "mgmt" {
  count               = var.number_of_firewalls
  name                = "${var.management_nic_name}-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "mgmt" {
  count               = var.number_of_firewalls
  name                = "${var.management_nic_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt[count.index].id
  }
}
# resource "azurerm_network_interface" "data" {
#   count               = var.number_of_firewalls
#   name                = "${var.data_nic_name}-${count.index + 1}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "ipconfig"
#     subnet_id                     = azurerm_subnet.data.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
resource "azurerm_network_interface" "untrust" {
  count                         = var.number_of_firewalls
  name                          = "${var.untrust_nic_name}-${count.index + 1}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true
  enable_ip_forwarding          = true

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.untrust.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "trust" {
  count                         = var.number_of_firewalls
  name                          = "${var.trust_nic_name}-${count.index + 1}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true
  enable_ip_forwarding          = true

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "firewall" {
  count                           = var.number_of_firewalls
  name                            = "${var.firewall_name}-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D3_v2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  # custom_data = var.custom_data
  network_interface_ids = [
    azurerm_network_interface.mgmt[count.index].id,
    # azurerm_network_interface.data[count.index].id,
    azurerm_network_interface.untrust[count.index].id,
    azurerm_network_interface.trust[count.index].id

  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = var.sku
    version   = var.palo_version
  }
  plan {
    name      = var.sku
    publisher = "paloaltonetworks"
    product   = "vmseries-flex"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "external" {
  count                   = var.number_of_firewalls
  network_interface_id    = azurerm_network_interface.untrust[count.index].id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_pool.id
}
resource "azurerm_network_interface_backend_address_pool_association" "internal" {
  count                   = var.number_of_firewalls
  network_interface_id    = azurerm_network_interface.trust[count.index].id
  ip_configuration_name   = "ipconfig" # must be updated if changed in virtual_appliance_pri.tf
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal_backends.id
}