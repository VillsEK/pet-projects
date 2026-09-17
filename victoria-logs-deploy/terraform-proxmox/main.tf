terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "myip"
  pm_api_token_id     = "root@pam!terraform"
  pm_api_token_secret = "my_token"
  pm_tls_insecure = true
  pm_minimum_permission_check = false
}

variable "k8s_nodes" {
  type = map(object({
    vmid   = number
    cores  = number
    memory = number
  }))
  default = {
    #"k8s-manager"  = { vmid = 103, cores = 4, memory = 4196 }
    "k8s-worker-1" = { vmid = 104, cores = 4, memory = 4196 }
    "k8s-worker-2" = { vmid = 105, cores = 4, memory = 4196 }
  }
}

resource "proxmox_vm_qemu" "k8s_cluster" {
  for_each = var.k8s_nodes

  name        = each.key
  vmid        = each.value.vmid
  target_node = "pve"
  clone       = "template-deb13"
  full_clone  = true
  agent       = 1
  timeouts {
    create = "1h" 
  }
  cpu {
    cores = each.value.cores
  }

  memory = each.value.memory

  disk {
    slot    = "scsi0"
    size    = "32G"
    type    = "disk"
    storage = "pve-ssd"
  }

  network {
    model  = "virtio"
    id     = "0"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=dhcp"
}