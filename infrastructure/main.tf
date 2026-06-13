resource "azurerm_resource_group" "blog" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

module "static_web_app" {
  source  = "Azure/avm-res-web-staticsite/azurerm"
  version = "~> 0.6"

  location            = azurerm_resource_group.blog.location
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.blog.name

  sku_size = "Free"
  sku_tier = "Free"

  tags = var.tags
}

module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.7"

  location  = azurerm_resource_group.blog.location
  name      = var.storage_account_name
  parent_id = azurerm_resource_group.blog.id

  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  # Allow public blob access for the gallery CDN
  allow_nested_items_to_be_public = true
  public_network_access_enabled   = true

  containers = {
    blog_media = {
      name          = "blog-media"
      public_access = "Blob"
    }
  }

  tags = var.tags
}
