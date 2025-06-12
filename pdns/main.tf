terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.73.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_tls_insecure
}

# Génération des VM en boucle via un for_each
resource "proxmox_virtual_environment_vm" "vms" {
  for_each = { for vm in var.vms : vm.name => vm }

  node_name    = var.proxmox_node
  name         = each.value.name
  description  = each.value.description
  tags         = each.value.tags
  vm_id        = each.value.vm_id

  clone {
    vm_id        = var.template_vm_id
    full         = true
    datastore_id = var.storage_pool
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = each.value.cpu_cores
    sockets = each.value.cpu_sockets
    type    = "host"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = var.storage_pool
    size         = each.value.disk_size_gb
    interface    = "scsi0"
    discard      = "on"
    file_format  = "raw"
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = var.gateway_ip
      }
    }

    dns {
      domain  = var.domain
      servers = var.nameserver
    }

    user_account {
      username = "root"
      password = var.root_password
      keys     = [var.ssh_public_keys]
    }

    datastore_id = var.storage_pool
    interface    = "ide2"
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      initialization[0].datastore_id,
    ]
  }
}

# Optionnel : Output des IPs
output "vm_ips" {
  value = { for vm in var.vms : vm.name => vm.ip_address }
}
