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


resource "azurerm_resource_group" "rubi-resource-group" {
  name     = "terraform-azure-vm-rg"
  location = "South Africa North"
}


resource "azurerm_virtual_network" "rubi-vnet" {
    name = "terraform-azure-vm-vnet"
    location = "South Africa North"
    resource_group_name = azurerm_resource_group.rubi-resource-group.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "rubi-public-subnet" {
  name                 = "terraform-azure-vm-public-snet"
  resource_group_name  = azurerm_resource_group.rubi-resource-group.name
  virtual_network_name = azurerm_virtual_network.rubi-vnet.name
  address_prefixes     = ["10.0.10.0/24"]

}

resource "azurerm_public_ip" "rubi-pip" {
  name                = "terraform-azure-vm-pip"
  resource_group_name = azurerm_resource_group.rubi-resource-group.name
  location            = azurerm_resource_group.rubi-resource-group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    create_before_destroy = true
  }


}


resource "azurerm_network_interface" "rubi-nic" {
  name                = "terraform-vm-nic"
  location            = azurerm_resource_group.rubi-resource-group.location
  resource_group_name = azurerm_resource_group.rubi-resource-group.name

  ip_configuration {
    name                          = "terraform-vm-nic-ipconfig"
    subnet_id                     = azurerm_subnet.rubi-public-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rubi-pip.id
  }
}


resource "azurerm_virtual_machine" "rubi-vm" {
  name                  = "terrafprm-azurevm"
  location              = azurerm_resource_group.rubi-resource-group.location
  resource_group_name   = azurerm_resource_group.rubi-resource-group.name
  network_interface_ids = [azurerm_network_interface.rubi-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

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
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}


output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value = azurerm_public_ip.rubi-pip.ip_address
}

