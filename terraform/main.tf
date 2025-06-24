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
    retries      = 3
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
    size         = var.disable_disk_resize ? null : each.value.disk_size_gb
    interface    = "scsi0"
    discard      = "on"
    file_format  = "qcow2"
    backup       = true
    replicate    = false
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
    create_before_destroy = false
  }
}

# Optionnel : Output des IPs
output "vm_ips" {
  value = { for vm in var.vms : vm.name => vm.ip_address }
}

# Output des informations de connexion
output "connection_info" {
  value = {
    for vm in var.vms : vm.name => {
      ip_address = vm.ip_address
      vm_id      = vm.vm_id
      ssh_command = "ssh -i ${var.ssh_private_key_path} root@${vm.ip_address}"
    }
  }
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/templates/inventory.tpl", {
    vm_ips               = { for vm in var.vms : vm.name => vm.ip_address }
    ssh_private_key_path = var.ssh_private_key_path
  })
  filename = "${path.module}/../ansible/inventory.yml"
}

resource "null_resource" "ansible_provision" {
  count = var.skip_ansible_provisioning ? 0 : 1
  
  depends_on = [
    proxmox_virtual_environment_vm.vms,
    local_file.ansible_inventory
  ]
  
  provisioner "local-exec" {
    command     = "powershell.exe -ExecutionPolicy Bypass -File ./run-ansible.ps1"
    working_dir = path.module
  }
}
