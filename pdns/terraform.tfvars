proxmox_api_url = "https://10.249.254.142:8006/api2/json"
proxmox_api_token = "terraform@pve!provider=1e8c614a-6e39-49b2-84bb-c1a71abc0c17"
proxmox_tls_insecure = true
proxmox_node = "pve-worker-1"
vm_template_file_id = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
storage_pool = "local-zfs"
ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8MZrnPQ21iMCzZzX8MOY48k9Q+KIpmPh3Fqm8uF6Kr+4LRE1JnDQ6Ol9AuaIwK4rwHl/uI6nDf/hoX+nIrbO4uFRDuUU5k8umBlCmfC1OA0NcLtbhaxF9+yrrmm7aP0XqNli/ysmiE3mejcWxHDZN26K35y3ebRaahJh0r1N+DqiPwvH8kwiLctvvhB7pQchYPtmMd+a/Pskp+LLPwitgx4jP34b1HGPl5KE7QBx1GGN1pHFnt4mnEZK996gqbaTgVBOUYi8APRbn9dZzXd0y3SclxHpKDogG0jUV/PywVLcROj0D+5/Wlha/gh3lcUGm2YVJRRJcdOixreOHsOFc3kZ6wrFQMEgBAlnKhjHZnCooBJEUWeEcf69iPsAu3eLjQxmeY5aBzcj+oZUwFnd2eoTYg3HGYboKYBpMPIgsORgCuyYv/N69VJ6OuwmkjVOdczrX9uCpFS//PFUzzuEVsoWp1PGj2LyvqHjk4A3MCZhBSL1mDENOIu+p9jxG4VknvOv5tXpJUUcR1RY8iTowCQyarmwfFmsUyjqfN2p8ddpnMx+ZKGJh2q7cFL+ofAC0B6UR5H6VxdhLKV/wxpgd0E6I6+n+MigSsUVWUeV0p/HfyVvVR4zqDsLv6+1vaDhOStNpF7zY/MDxt1zdvjhW+rzEN5R0rxZtndEllh2zyw== evanv@LAPTOP-I1TKGGFB"
ssh_private_key_path = "~/.ssh/id_rsa"
network_bridge = "vmbr0"
dns_primary_ip = "10.249.254.79"
dns_secondary_ip = "10.249.254.84"
gateway_ip = "10.249.254.1"
domain = "iuc.cs"
nameserver = ["1.1.1.1", "8.8.8.8"]
dns_primary_container_id = 100
dns_secondary_container_id = 101
root_password = "evan1234"