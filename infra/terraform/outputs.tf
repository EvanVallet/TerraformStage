output "vm_ips" {
  value = { for vm in var.vms : vm.name => vm.ip_address }
}
