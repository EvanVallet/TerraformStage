variable "proxmox_api_url" {
  description = "URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token for Proxmox authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Whether to skip TLS verification for the Proxmox API"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Name of the Proxmox node"
  type        = string
}

variable "template_vm_id" {
  description = "ID of the container template to use"
  type        = string
}

variable "storage_pool" {
  description = "ID of the storage pool to use"
  type        = string
  default     = "local-zfs"
}

variable "network_bridge" {
  description = "Network bridge to attach the container to"
  type        = string
  default     = "vmbr0"
}

variable "gateway_ip" {
  description = "Gateway IP address"
  type        = string
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "nameserver" {
  description = "DNS server addresses for container configuration"
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

# Authentification SSH
variable "ssh_public_keys" {
  description = "SSH public key to add to authorized_keys"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key for provisioning"
  type        = string
}

variable "root_password" {
  description = "Root password for the containers"
  type        = string
  sensitive   = true
}

# Liste des VM à créer
variable "vms" {
  description = "List of VMs to create"
  type        = list(object({
    name          = string
    description   = string
    tags          = list(string)
    vm_id         = number
    ip_address    = string
    cpu_cores     = number
    cpu_sockets   = number
    memory_mb     = number
    disk_size_gb  = number
  }))
}