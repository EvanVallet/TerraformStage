proxmox_api_url = "https://10.249.254.139:8006/api2/json"
proxmox_api_token = "terraform@pam!terraform-token=ad1ae26a-0610-44dc-bfaf-bdc3d7addc57 "
proxmox_tls_insecure = true
proxmox_node = "pve"
container_template_file_id = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
storage_pool = "local-lvm"
ssh_public_keys = "<pub_key>"
ssh_private_key_path = "~/.ssh/<key>"
network_bridge = "vmbr0"
dns_primary_ip = "10.249.254.79"
dns_secondary_ip = "10.249.254.84"
gateway_ip = "10.249.254.1"
domain = "iuc.cs"
nameserver = ["1.1.1.1", "8.8.8.8"]
dns_primary_container_id = 100
dns_secondary_container_id = 101
root_password = "<password>"