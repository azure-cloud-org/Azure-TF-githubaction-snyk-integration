/*
# Create a resource group
resource "azurerm_resource_group" "myrg-sonarcloud" {
  name = "myrg-sonarcloud-integration"
  location = "East US"
}

# Create Virtual Network
# Create Virtual Network
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet-sonarcloud" {
  name                = "myvnet-sonarcloud-integration-demo"
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.myrg-sonarcloud.location
  resource_group_name = azurerm_resource_group.myrg-sonarcloud.name
}

# Create Subnet
resource "azurerm_subnet" "mysubnet-sonarcloud" {
  name                 = "mysubnet-sonarcloud-integration"
  resource_group_name  = azurerm_resource_group.myrg-sonarcloud.name
  virtual_network_name = azurerm_virtual_network.myvnet-sonarcloud.name
  address_prefixes     = ["10.1.0.0/27"]
}
*/


# Create a resource group
resource "azurerm_resource_group" "myrg-snyk-2" {
  name = "myrg-snyk-integration-2"
  location = "East US"
  tags = {
    env = "Dev"
    env = "prod"
    owner = "vivek"
  }
}

##Repeated commented lines to verify configured sonarcloud quality gate rule
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet-snyk-2" {
  name                = "myvnet-snyk-integration-demo-2"
  address_space       = ["10.5.0.0/24"]
  location            = azurerm_resource_group.myrg-snyk-2.location
  resource_group_name = azurerm_resource_group.myrg-snyk-2.name
  tags = {
    env = "Dev"
    env = "prod"
    owner = "vivek"
  }
}

# Create Subnet
resource "azurerm_subnet" "mysubnet-snyk" {
  name                 = "mysubnet-snyk-integration"
  resource_group_name  = azurerm_resource_group.myrg-snyk-2.name
  virtual_network_name = azurerm_virtual_network.myvnet-snyk-2.name
  address_prefixes     = ["10.5.0.0/27"]
}


##creating allow all inbound firewall rule to verify synk SAST detection
resource "azurerm_network_security_group" "example-synk" {
  name                = "example-nsg"
  location            = azurerm_resource_group.myrg-snyk-2.location
  resource_group_name = azurerm_resource_group.myrg-snyk-2.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.mysubnet-snyk.id
  network_security_group_id = azurerm_network_security_group.example-synk.id
}

##Storage account creation- unprotected storage account
resource "azurerm_storage_account" "example" {
  name                     = "sa21112022"
  resource_group_name      = azurerm_resource_group.myrg-snyk-2.name
  location                 = azurerm_resource_group.myrg-snyk-2.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "prod"
  }
}