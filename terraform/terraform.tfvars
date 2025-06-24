proxmox_api_url = "https://10.249.254.142:8006/api2/json"
proxmox_api_token = "terraform@pve!provider=1e8c614a-6e39-49b2-84bb-c1a71abc0c17"
proxmox_tls_insecure = true
proxmox_node = "pve-worker-1"
template_vm_id = "9000"
storage_pool = "local-zfs"
network_bridge = "vmbr0"
gateway_ip = "10.249.254.1"
domain = "iuc.cs"
nameserver = ["1.1.1.1", "8.8.8.8"]
ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8MZrnPQ21iMCzZzX8MOY48k9Q+KIpmPh3Fqm8uF6Kr+4LRE1JnDQ6Ol9AuaIwK4rwHl/uI6nDf/hoX+nIrbO4uFRDuUU5k8umBlCmfC1OA0NcLtbhaxF9+yrrmm7aP0XqNli/ysmiE3mejcWxHDZN26K35y3ebRaahJh0r1N+DqiPwvH8kwiLctvvhB7pQchYPtmMd+a/Pskp+LLPwitgx4jP34b1HGPl5KE7QBx1GGN1pHFnt4mnEZK996gqbaTgVBOUYi8APRbn9dZzXd0y3SclxHpKDogG0jUV/PywVLcROj0D+5/Wlha/gh3lcUGm2YVJRRJcdOixreOHsOFc3kZ6wrFQMEgBAlnKhjHZnCooBJEUWeEcf69iPsAu3eLjQxmeY5aBzcj+oZUwFnd2eoTYg3HGYboKYBpMPIgsORgCuyYv/N69VJ6OuwmkjVOdczrX9uCpFS//PFUzzuEVsoWp1PGj2LyvqHjk4A3MCZhBSL1mDENOIu+p9jxG4VknvOv5tXpJUUcR1RY8iTowCQyarmwfFmsUyjqfN2p8ddpnMx+ZKGJh2q7cFL+ofAC0B6UR5H6VxdhLKV/wxpgd0E6I6+n+MigSsUVWUeV0p/HfyVvVR4zqDsLv6+1vaDhOStNpF7zY/MDxt1zdvjhW+rzEN5R0rxZtndEllh2zyw== evanv@LAPTOP-I1TKGGFB"
ssh_private_key_path = "~/.ssh/id_rsa"
root_password = "ubuntu"

vms = [
  {
    name         = "pdns-primary"
    description  = "Primary PowerDNS server"
    tags         = ["dns", "primary"]
    vm_id        = 110
    ip_address   = "192.168.100.10"
    cpu_cores    = 4
    cpu_sockets  = 1
    memory_mb    = 2048
    disk_size_gb = 64
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "pdns-secondary"
    description  = "Secondary PowerDNS server"
    tags         = ["dns", "secondary"]
    vm_id        = 111
    ip_address   = "192.168.100.11"
    cpu_cores    = 2
    cpu_sockets  = 1
    memory_mb    = 2048
    disk_size_gb = 32
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "openldap"
    description  = "OpenLDAP directory server"
    tags         = ["ldap"]
    vm_id        = 112
    ip_address   = "192.168.100.12"
    cpu_cores    = 2
    cpu_sockets  = 1
    memory_mb    = 8192
    disk_size_gb = 32
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "db-node1"
    description  = "MariaDB Galera Cluster Node 1"
    tags         = ["db", "cluster"]
    vm_id        = 113
    ip_address   = "192.168.100.13"
    cpu_cores    = 4
    cpu_sockets  = 1
    memory_mb    = 2048
    disk_size_gb = 64
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "db-node2"
    description  = "MariaDB Galera Cluster Node 2"
    tags         = ["db", "cluster"]
    vm_id        = 114
    ip_address   = "192.168.100.14"
    cpu_cores    = 4
    cpu_sockets  = 1
    memory_mb    = 2048
    disk_size_gb = 64
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "db-node3"
    description  = "MariaDB Galera Cluster Node 3"
    tags         = ["db", "cluster"]
    vm_id        = 115
    ip_address   = "192.168.100.15"
    cpu_cores    = 4
    cpu_sockets  = 1
    memory_mb    = 2048
    disk_size_gb = 64
    proxmox_node = "pve-worker-1"
  },
  {
    name         = "moodle"
    description  = "Moodle e-learning platform"
    tags         = ["moodle", "app"]
    vm_id        = 116
    ip_address   = "192.168.100.16"
    cpu_cores    = 4
    cpu_sockets  = 1
    memory_mb    = 8192
    disk_size_gb = 64
    proxmox_node = "pve-worker-1"
  }
]