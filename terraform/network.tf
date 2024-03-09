# Create virtual network
resource "azurerm_virtual_network" "webapp_vote_mba_network" {
  name                = "webapp-vote-mba-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.webapp_vote_mba_rg.location
  resource_group_name = azurerm_resource_group.webapp_vote_mba_rg.name
}

# Create subnet
resource "azurerm_subnet" "webapp_vote_mba_subnet_internal" {
  name                 = "webapp-vote-mba-internal"
  resource_group_name  = azurerm_resource_group.webapp_vote_mba_rg.name
  virtual_network_name = azurerm_virtual_network.webapp_vote_mba_network.name
  address_prefixes     = ["10.0.2.0/24"]
}
