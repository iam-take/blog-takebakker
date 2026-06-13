output "resource_group_id" {
  description = "The ID of the blog resource group."
  value       = azurerm_resource_group.blog.id
}

output "static_web_app_default_hostname" {
  description = "The default hostname of the Static Web App (e.g. random-name.azurestaticapps.net). Use this for DNS CNAME records."
  value       = module.static_web_app.resource.default_host_name
}

output "static_web_app_api_key" {
  description = "The deployment API key for the Static Web App. Add this to GitHub Secrets as AZURE_STATIC_WEB_APPS_API_TOKEN."
  sensitive   = true
  value       = module.static_web_app.resource.api_key
}

output "storage_account_blob_endpoint" {
  description = "The primary blob endpoint for the storage account. Use as the base URL for gallery images."
  value       = "https://${var.storage_account_name}.blob.core.windows.net/blog-media/gallery/"
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = var.storage_account_name
}
