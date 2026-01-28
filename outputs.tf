output "public_ip_address" {
  description = "Adresse IP publique de la VM"
  value       = azurerm_public_ip.tp_public_ip.ip_address
}
