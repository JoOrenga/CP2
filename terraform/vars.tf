# =============================================================================
# variables.tf
# =============================================================================
variable "subscription_id" {
  description = "ID de suscripción. Vacío si usas ARM_SUBSCRIPTION_ID."
  type        = string
  default     = ""
}

variable "location" {
  description = "Región (cuenta de estudiante: NO West Europe)."
  type        = string
  default     = "swedencentral"
}

variable "resource_group_name" {
  type    = string
  default = "rg-cp2-jorengap"
}

variable "acr_name" {
  description = "Nombre del ACR (único global, minúsculas y números)."
  type        = string
  default     = "cp2acrjorengap"
}

variable "network_name" {
  default = "vnet1"
}

variable "subnet_name" {
  default = "subnet1"
}