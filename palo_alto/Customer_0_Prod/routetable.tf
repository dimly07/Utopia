
resource "azurerm_route_table" "mgmt" {
  name                = var.mgmt_table_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_route_table_association" "mgmt" {
  subnet_id      = azurerm_subnet.mgmt.id
  route_table_id = azurerm_route_table.mgmt.id
}

resource "azurerm_route_table" "untrust" {
  name                = var.untrust_table_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_route_table_association" "untrust" {
  subnet_id      = azurerm_subnet.untrust.id
  route_table_id = azurerm_route_table.untrust.id
}

resource "azurerm_route_table" "trust" {
  name                = var.trust_table_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_route_table_association" "trust" {
  subnet_id      = azurerm_subnet.trust.id
  route_table_id = azurerm_route_table.trust.id
}