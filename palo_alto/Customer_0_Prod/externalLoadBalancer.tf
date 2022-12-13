resource "azurerm_public_ip" "extlb-pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "extlb" {
  name                = var.external_lb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "elb-pip"
    public_ip_address_id = azurerm_public_ip.extlb-pip.id
  }
}
resource "azurerm_lb_backend_address_pool" "firewall_pool" {
  loadbalancer_id = azurerm_lb.extlb.id
  name            = "pafw-untrust-backend-pool"
}

# resource "azurerm_network_interface_backend_address_pool_association" "firewalls_untrust" {
#   count                   = var.number_of_firewalls
#   network_interface_id    = azurerm_network_interface.untrust[count.index].id
#   ip_configuration_name   = "nic-pafwuntrust-prod-eus"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_pool.id
# }

resource "azurerm_lb_rule" "consumer" {
  loadbalancer_id                = azurerm_lb.extlb.id
  name                           = "ext-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "elb-pip"
  probe_id                       = azurerm_lb_probe.external_ssh_probe.id
  load_distribution              = "SourceIPProtocol"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.firewall_pool.id]
}
resource "azurerm_lb_probe" "external_ssh_probe" {
  # resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.extlb.id
  name            = "ssh-health-probe"
  port            = 22
}