# Required variables

variable "location" {
  type        = string
  description = "Azure region where all resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create for the blog infrastructure."
}

variable "static_web_app_name" {
  type        = string
  description = "Name of the Azure Static Web App resource."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account for blog media (photos). Must be globally unique, 3-24 lowercase alphanumeric characters."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID to deploy all resources into."
}

# Optional variables

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
  nullable    = false
}
