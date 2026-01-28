# --- Azure / Infra de base ---
variable "location" {
  description = "Région Azure"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
  default     = "tp-web-rg"
}

variable "vnet_name" {
  description = "Nom du VNet"
  type        = string
  default     = "tp-vnet"
}

variable "vnet_address_space" {
  description = "CIDR du VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Nom du subnet"
  type        = string
  default     = "vm-subnet"
}

variable "subnet_address_prefixes" {
  description = "CIDR du subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "Nom de l'IP publique"
  type        = string
  default     = "tp-public-ip"
}

variable "nsg_name" {
  description = "Nom du NSG"
  type        = string
  default     = "tp-nsg"
}

variable "nic_name" {
  description = "Nom de la NIC"
  type        = string
  default     = "tp-nic"
}

# --- VM ---
variable "vm_name" {
  description = "Nom de la VM"
  type        = string
  default     = "vm-web-apache"
}

variable "vm_size" {
  description = "Taille de la VM"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Utilisateur admin de la VM"
  type        = string
  default     = "adminuser"
}

# --- Variables d'Authentification ---
variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

# --- SSH Key (Injectée par le pipeline) ---
variable "ssh_public_key" {
  description = "Clé publique injectée dynamiquement par GitHub Actions"
  type        = string
}
