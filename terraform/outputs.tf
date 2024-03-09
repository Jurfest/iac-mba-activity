output "public_ips" {
  description = "The public IPs of the virtual machines"
  value       = azurerm_public_ip.webapp_vote_mba[*].ip_address
}
