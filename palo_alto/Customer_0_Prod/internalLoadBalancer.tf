resource "azurerm_lb" "internal" {
  name                = var.internal_lb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
  }
}

resource "azurerm_lb_probe" "internal_ssh_probe" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "ssh-health-probe"
  port            = 22
}

resource "azurerm_lb_rule" "internal_01" {
  loadbalancer_id                = azurerm_lb.internal.id
  name                           = "ilb-lb-rule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "internal"
  probe_id                       = azurerm_lb_probe.internal_ssh_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal_backends.id]
  load_distribution              = "SourceIPProtocol"
  enable_floating_ip             = true
}

resource "azurerm_lb_backend_address_pool" "internal_backends" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "pafw-trust-backend-pool"
}
# resource "azurerm_network_interface_backend_address_pool_association" "firewalls_trust" {
#   count                   = var.number_of_firewalls
#   network_interface_id    = azurerm_network_interface.trust[count.index].id
#   ip_configuration_name   = "nic-pafwtrust-prod-eus"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_pool.id
# }

