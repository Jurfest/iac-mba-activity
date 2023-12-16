resource "azurerm_resource_group" "ubuntu" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "Terraform Azure"
  }
}