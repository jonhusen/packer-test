packer {
  required_plugins {
    vsphere = {
      version = "~> 1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

variable "image_id" {
  type = string
  description = "The name of the vm"
  default = "rocky_93_base"
}

source "vsphere-iso" var.image_id {
  CPUs                 = 2
  CPUs_hot_plug        = true
  RAM                  = 4096
  RAM_hot_plug         = true
  RAM_reserve_all      = false
  boot_command         = ["e<down><down><end><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<leftCtrlOn>x<leftCtrlOff>"]
  disk_controller_type = ["pvscsi"]
  floppy_files         = ["${path.root}/preseed.cfg"]
  guest_os_type        = "rockylinux-64"
  host                 = "vcsa.husen.local"
  insecure_connection  = true
  iso_paths            = ["[freenas-nfs] Linux/rocky/Rocky-9.3-x86_64-minimal.iso"]
  network_adapters {
    network_card = "vmxnet3"
  }
  password     = "jetbrains"
  ssh_password = "jetbrains"
  ssh_username = "jetbrains"
  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }
  username       = "root"
  vcenter_server = "vcenter.example.com"
  vm_name        = "example-ubuntu"
}


build {
  post-processors {
    post-processor "vsphere"{
      vm_name             = var.image_id
      host                = "vcsa.husen.local"
      username            = "administrator@vsphere.local"
      password            = "VMw@re1!"
      datacenter          = "dc-01"
      cluster             = "cluster-01"
      datastore           = "datastore-01"
      vm_network          = "VM Network"
      keep_input_artifact = true
    }
  }
}