terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"  # Conexión al hipervisor KVM
}

# Crear el volumen de disco para el sistema operativo
resource "libvirt_volume" "debian_image" {
  name   = "debian-12-generic-amd64.qcow2"
  pool   = "default"
  source = "https://cloud.debian.org/images/cloud/bookworm/20230531-1397/debian-12-generic-amd64-20230531-1397.qcow2"
  format = "qcow2"
}

# Crear la máquina virtual
resource "libvirt_domain" "debian_vm" {
  name   = "debian-vm01"
  memory = 1024  # 1 GB de RAM
  vcpu   = 1

  # Disco de la máquina virtual
  disk {
    volume_id = libvirt_volume.debian_image.id
  }

  # Interfaz de red
  network_interface {
    network_name = "default"  # Conexión a la red 'default'
  }
}