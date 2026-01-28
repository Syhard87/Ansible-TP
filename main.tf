# ---------------------------------------------------------
# 1. RÉSEAU & INFRASTRUCTURE
# ---------------------------------------------------------

resource "azurerm_resource_group" "tp_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "tp_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.tp_rg.location
  resource_group_name = azurerm_resource_group.tp_rg.name
}

resource "azurerm_subnet" "tp_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.tp_rg.name
  virtual_network_name = azurerm_virtual_network.tp_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "tp_public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.tp_rg.name
  location            = azurerm_resource_group.tp_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "tp_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.tp_rg.location
  resource_group_name = azurerm_resource_group.tp_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tp_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.tp_rg.location
  resource_group_name = azurerm_resource_group.tp_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tp_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tp_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tp_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.tp_nic.id
  network_security_group_id = azurerm_network_security_group.tp_nsg.id
}

# ---------------------------------------------------------
# 2. MACHINE VIRTUELLE
# ---------------------------------------------------------

resource "azurerm_linux_virtual_machine" "tp_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.tp_rg.name
  location              = azurerm_resource_group.tp_rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.tp_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

# ---------------------------------------------------------
# 3. OUTPUTS
# ---------------------------------------------------------

output "vm_public_ip" {
  value = azurerm_public_ip.tp_public_ip.ip_address
}
