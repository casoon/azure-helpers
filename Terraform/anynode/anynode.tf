provider "azurerm" {
    version = "=2.0.0"
    subscription_id = var.subscriptionId
    client_id       = var.clientId
    client_secret   = var.clientSecret
    tenant_id       = var.tenantId
    features {}
}

resource "azurerm_resource_group" "anynodegroup" {
    name     = "${var.customer}-${var.project}-rg-${var.environment}"
    location = "${var.location}"

    tags = {
        environment = var.tag
    }
}

resource "azurerm_virtual_network" "anynodenetwork" {
    name                = "${var.project}-vnet-${var.environment}"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = azurerm_resource_group.anynodegroup.name

    tags = {
        environment = var.tag
    }
}

resource "azurerm_subnet" "anynodesubnet" {
    name                 = "${var.project}-vnet-${var.environment}"
    resource_group_name  = azurerm_resource_group.anynodegroup.name
    virtual_network_name = azurerm_virtual_network.anynodenetwork.name
    address_prefix       = "10.0.2.0/24"

}

resource "azurerm_public_ip" "anynodepublicip" {
    name                         = "${var.project}-pip-${var.environment}"
    location                     = "${var.location}"
    resource_group_name          = azurerm_resource_group.anynodegroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.tag
    }
}

resource "azurerm_network_security_group" "anynodensg" {
    name                = "${var.project}-nsg-${var.environment}"
    location            = "${var.location}"
    resource_group_name = azurerm_resource_group.anynodegroup.name
    
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
        name                       = "HTTPS"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.tag
    }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.anynodesubnet.id
  network_security_group_id = azurerm_network_security_group.anynodensg.id
}


resource "azurerm_network_interface" "anynodenic" {
    name                        = "${var.project}-nic-${var.environment}"
    location                    = "${var.location}"
    resource_group_name         = azurerm_resource_group.anynodegroup.name


    ip_configuration {
        name                          = "anynodeNicConfiguration"
        subnet_id                     = "${azurerm_subnet.anynodesubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.anynodepublicip.id}"
    }

    tags = {
        environment = var.tag
    }
}

resource "random_id" "randomId" {
    keepers = {
        resource_group = azurerm_resource_group.anynodegroup.name
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "anynodestorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.anynodegroup.name
    location                    = "${var.location}"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = var.tag
    }
}

resource "azurerm_virtual_machine" "anynodevm" {
    name                  = "${var.project}-vm-${var.environment}"
    location              = "${var.location}"
    resource_group_name   = azurerm_resource_group.anynodegroup.name
    network_interface_ids = [azurerm_network_interface.anynodenic.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.project}OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Debian"
        offer     = "debian-10"
        sku       = "10"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.project}vm"
        admin_username = "${var.user}"
        admin_password = "${var.password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.anynodestorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = var.tag
    }

    provisioner "remote-exec" {
        connection {
            type     = "ssh"
            user     = "${var.user}"
            password = "${var.password}"
            host     = azurerm_public_ip.anynodepublicip.ip_address
        }


        inline = [
            "wget https://linux.te-systems.de/anynode_debian_install.bash",
            "source ./anynode_debian_install.bash eth0",
        ]
    }

}