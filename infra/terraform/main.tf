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
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = { for vm in var.vms : vm.name => vm }
  node_name = var.proxmox_node
  name      = each.value.name
  vm_id     = each.value.vm_id
  description = "VM ${each.value.name}"
  tags      = ["managed"]

  clone {
    vm_id        = var.template_vm_id
    full         = true
    datastore_id = var.storage_pool
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    sockets = 1
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = var.storage_pool
    size         = 32
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
        gateway = "192.168.100.1"
      }
    }

    user_account {
      username = "root"
      password = "SuperSecret"
      keys     = [file("${path.module}/ssh_keys/id_rsa.pub")]
    }

    datastore_id = var.storage_pool
    interface    = "ide2"
  }

  operating_system {
    type = "l26"
  }
}
