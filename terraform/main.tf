# Create network interface
resource "azurerm_network_interface" "webapp_vote_mba_nic" {
  count               = 1
  name                = "WEBAPP-VOTE-MBA-NIC-${count.index}"
  location            = azurerm_resource_group.webapp_vote_mba_rg.location
  resource_group_name = azurerm_resource_group.webapp_vote_mba_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.webapp_vote_mba_subnet_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.webapp_vote_mba.*.id, count.index)
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "webapp_vote_mba_vm" {
  name                = "WEBAPP-VOTE-MBA-VM-${count.index}"
  count               = 1
  resource_group_name = azurerm_resource_group.webapp_vote_mba_rg.name
  location            = azurerm_resource_group.webapp_vote_mba_rg.location
  size                = "Standard_ds1_v2"
  admin_username      = var.username
  network_interface_ids = [
    element(azurerm_network_interface.webapp_vote_mba_nic.*.id, count.index)
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
resource "azurerm_public_ip" "webapp_vote_mba" {
  count               = 1
  name                = "WEBAPP-VOTE-MBA-PUBLIC-IP-${count.index}"
  resource_group_name = azurerm_resource_group.webapp_vote_mba_rg.name
  location            = azurerm_resource_group.webapp_vote_mba_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
    team        = "iac"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "webapp_vote_mba_security_group" {
  name                = "webapp-vote-mba-security-group1"
  location            = azurerm_resource_group.webapp_vote_mba_rg.location
  resource_group_name = azurerm_resource_group.webapp_vote_mba_rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

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
resource "azurerm_network_interface_security_group_association" "webapp_vote_mba" {
  count                     = 1
  network_interface_id      = element(azurerm_network_interface.webapp_vote_mba_nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.webapp_vote_mba_security_group.id
}

# Create (and display) an SSH key
resource "tls_private_key" "secureadmin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
