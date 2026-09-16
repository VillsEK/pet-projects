terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "url"
  pm_api_token_id     = "root@pam!terraform"
  pm_api_token_secret = "api"
  pm_tls_insecure = true
  pm_minimum_permission_check = false
}

resource "proxmox_vm_qemu" "my-k8s" {
  name        = "k8s-manager"
  target_node = "pve"
  clone       = "template-debian13"
  vmid        = "103"

  cores  = 4
  memory = 4196
  agent   = 1
    
  full_clone  = true 
  ipconfig0 = "ip=dhcp"
  
  disk {
    slot    = "scsi0"
    size    = "32G"      
    type    = "disk"
    storage = "pve-hard" 
  }
}