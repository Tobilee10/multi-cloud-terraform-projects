terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "react-app-rg" {
  name     = "react-app-rg"
  location = "South Africa North"
}


resource "azurerm_virtual_network" "react-app-vnet" {
    name = "react-app-vnet"
    location = "South Africa North"
    resource_group_name = azurerm_resource_group.react-app-rg.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "react-public-subnet" {
  name                 = "terraform-azure-vm-public-snet"
  resource_group_name  = azurerm_resource_group.react-app-rg.name
  virtual_network_name = azurerm_virtual_network.react-app-vnet.name
  address_prefixes     = ["10.0.10.0/24"]

}

resource "azurerm_public_ip" "react-pip" {
  name                = "terraform-azure-vm-pip"
  resource_group_name = azurerm_resource_group.react-app-rg.name
  location            = azurerm_resource_group.react-app-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    create_before_destroy = true
  }

}


resource "azurerm_network_interface" "react-nic" {
  name                = "terraform-vm-nic"
  location            = azurerm_resource_group.react-app-rg.location
  resource_group_name = azurerm_resource_group.react-app-rg.name

  ip_configuration {
    name                          = "terraform-vm-nic-ipconfig"
    subnet_id                     = azurerm_subnet.react-public-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.react-pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.react-nic.id
  network_security_group_id = azurerm_network_security_group.react-nsg.id
}




resource "azurerm_network_security_group" "react-nsg" {
  name                = "react-app-nsg"
  location            = azurerm_resource_group.react-app-rg.location
  resource_group_name = azurerm_resource_group.react-app-rg.name

  security_rule {
    name                       = "Allow-SSH"
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
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_virtual_machine" "react-vm" {
  name                  = "react-app-vm"
  location              = azurerm_resource_group.react-app-rg.location
  resource_group_name   = azurerm_resource_group.react-app-rg.name
  network_interface_ids = [azurerm_network_interface.react-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "ubuntu"
    admin_password = "user1234!"
    custom_data = filebase64("${path.module}/setup-react.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}


output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value = azurerm_public_ip.react-pip.ip_address
}

