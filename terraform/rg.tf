resource "azurerm_resource_group" "webapp_vote_mba" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "Terraform Azure"
  }
}
