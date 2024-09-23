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
  name   = "debian-disk.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = 10 * 1024 * 1024 * 1024  # 10 GB
}

# Crear el volumen para la ISO de Debian
resource "libvirt_volume" "debian_iso" {
  name   = "debian-11.iso"
  pool   = "default"
  source = "/home/lucas/debian-12.7.0-amd64-DVD-1.iso"  # Ruta a la ISO de Debian
  format = "raw"
}

# Crear la máquina virtual
resource "libvirt_domain" "debian_vm" {
  name   = "debian-vm"
  memory = 1024  # 1 GB de RAM
  vcpu   = 1

 # CD-ROM con la ISO de Debian
  disk {
    volume_id = libvirt_volume.debian_iso.id
    scsi      = true  # Para configurar como dispositivo de CD-ROM
  }

  # Disco de la máquina virtual
  disk {
    volume_id = libvirt_volume.debian_image.id
  }

  # Interfaz de red
  network_interface {
    network_name = "default"  # Conexión a la red 'default'
  }
}
