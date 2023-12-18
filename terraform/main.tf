# Create network interface
resource "azurerm_network_interface" "ubuntu" {
  count               = 1
  name                = "UBUNTU-NIC-${count.index}"
  location            = azurerm_resource_group.ubuntu.location
  resource_group_name = azurerm_resource_group.ubuntu.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ubuntu.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.ubuntu.*.id, count.index)

  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                = "UBUNTU-VM-${count.index}"
  count               = 1
  resource_group_name = azurerm_resource_group.ubuntu.name
  location            = azurerm_resource_group.ubuntu.location
  size                = "Standard_ds1_v2"
  admin_username      = var.username
  network_interface_ids = [
    element(azurerm_network_interface.ubuntu.*.id, count.index)
    ,
  ]
  admin_ssh_key {
    username   = var.username
    public_key = file("../ssh-keys/swarm-cluster.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    # offer     = "UbuntuServer"
    # sku       = "19.04"
    # sku = "18.04-LTS"
    # sku       = "16.04-LTS"
    offer   = "0001-com-ubuntu-server-focal"
    sku     = "20_04-lts-gen2"
    version = "latest"
  }

}

# Create public IPs
resource "azurerm_public_ip" "ubuntu" {
  count               = 1
  name                = "UBUNTU-VM-NIC-0${count.index}"
  resource_group_name = azurerm_resource_group.ubuntu.name
  location            = azurerm_resource_group.ubuntu.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
    team        = "iac"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "ubuntu" {
  name                = "ubuntu-security-group1"
  location            = azurerm_resource_group.ubuntu.location
  resource_group_name = azurerm_resource_group.ubuntu.name

  security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
    team        = "iac"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "ubuntu" {
  count                     = 1
  network_interface_id      = element(azurerm_network_interface.ubuntu.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.ubuntu.id
}

# Create (and display) an SSH key
resource "tls_private_key" "secureadmin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
