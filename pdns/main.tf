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

resource "proxmox_virtual_environment_vm" "pdns_primary" {
  node_name    = var.proxmox_node
  name         = "pdns-primary"
  description  = "pdns server VM"
  tags         = ["pdns", "server"]
  vm_id        = var.dns_primary_container_id
  
  # Clone from template with storage target specified
  clone {
    vm_id = var.template_vm_id
    full  = true
    datastore_id = var.storage_pool
  }
  
  # VM specific settings
  agent {
    enabled = true
  }
  
  # Resource allocation
  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }
  memory {
    dedicated = 16384
  }
  
  # Disk configuration
  disk {
    datastore_id = var.storage_pool
    size         = 64
    interface    = "scsi0"
    discard      = "on"
    file_format  = "raw"
  }
  
  # Network configuration
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }
  
  # Cloud-init configuration
  initialization {
    ip_config {
      ipv4 {
        address = "${var.dns_primary_ip}/24"
        gateway = var.gateway_ip
      }
    }
    
    dns {
      domain = var.domain
      servers = var.nameserver
    }
    
    user_account {
      username = "root"
      password = var.root_password
      keys     = [var.ssh_public_keys]
    }
    
    # Cloud-init settings as part of the standard configuration
    # Remove the user_data attribute and instead use these settings:
    datastore_id = var.storage_pool
    interface    = "ide2"
  }

  operating_system {
    type = "l26"
  }

  # Add cloud-init custom settings outside initialization block
  lifecycle {
    ignore_changes = [
      initialization[0].datastore_id,
    ]
  }
  
}

# Use local-exec instead of remote-exec initially to wait for VM to be accessible
resource "null_resource" "wait_for_vm" {
  depends_on = [proxmox_virtual_environment_vm.pdns_primary]  # Correction ici

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for VM to become accessible..."
      count=0
      max_attempts=30
      until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.ssh_private_key_path} root@${var.dns_primary_ip} echo "VM is accessible" || [ $count -eq $max_attempts ]
      do
        sleep 10
        count=$((count+1))
        echo "Attempt $count/$max_attempts: Waiting for VM to be accessible..."
      done
    EOT
  }
}

# Use a separate null_resource for provisioners after we know the VM is accessible
resource "null_resource" "pdns_provisioner" {
  depends_on = [null_resource.wait_for_vm]

  # Copy setup scripts
  provisioner "file" {
    source      = "${path.module}/script/setup.sh"  # Correction du chemin
    destination = "/tmp/setup.sh"
    
    connection {
      type        = "ssh"
      user        = "root"
      host        = var.dns_primary_ip
      private_key = file(var.ssh_private_key_path)
    }
  }
  

}