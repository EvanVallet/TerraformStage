variable "proxmox_api_url" {}
variable "proxmox_api_token" {}
variable "proxmox_node" {}
variable "template_vm_id" {}
variable "storage_pool" {}
variable "network_bridge" {}

variable "vms" {
  type = list(object({
    name       = string
    vm_id      = number
    ip_address = string
  }))
}
