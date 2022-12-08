variable "number_of_public_ips" {
  type        = number
  default     = 2
  description = "Number of Public IPs added for external load balancer"
}
variable "public_ip_name" {
  type        = string
  description = "Name of Public IP address"
}
variable "external_lb_name" {
  type        = string
  description = "Name of the internal load balancer for trust traffic"
}
resource "azurerm_public_ip" "extlb_pip" {
  count               = var.number_of_public_ips
  name                = "${var.public_ip_name}-${count.index + 1}"
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
    name                 = "inbound-1"
    public_ip_address_id = azurerm_public_ip.extlb_pip[0].id
  }
  frontend_ip_configuration {
    name                 = "inbound-2"
    public_ip_address_id = azurerm_public_ip.extlb_pip[1].id
  }
}
resource "azurerm_lb_backend_address_pool" "firewall_pool" {
  count           = var.number_of_public_ips
  loadbalancer_id = azurerm_lb.extlb.id
  name            = "pafw-untrust-backend-pool-${count.index + 1}"
}

# resource "azurerm_network_interface_backend_address_pool_association" "firewalls_untrust" {
#   count                   = var.number_of_firewalls
#   network_interface_id    = azurerm_network_interface.untrust[count.index].id
#   ip_configuration_name   = "nic-pafwuntrust-prod-eus"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.firewall_pool.id
# }

resource "azurerm_lb_rule" "inbound_1" {
  loadbalancer_id                = azurerm_lb.extlb.id
  name                           = "ext-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "inbound-1"
  probe_id                       = azurerm_lb_probe.external_ssh_probe.id
  load_distribution              = "SourceIPProtocol"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.firewall_pool[0].id]
}
resource "azurerm_lb_rule" "inbound_2" {
  loadbalancer_id                = azurerm_lb.extlb.id
  name                           = "ext-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "inbound-2"
  probe_id                       = azurerm_lb_probe.external_ssh_probe.id
  load_distribution              = "SourceIPProtocol"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.firewall_pool[1].id]
}
resource "azurerm_lb_probe" "external_ssh_probe" {
  # resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id = azurerm_lb.extlb.id
  name            = "ssh-health-probe"
  port            = 22
}