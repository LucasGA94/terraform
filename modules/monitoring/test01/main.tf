terraform {
   backend "remote" {
    hostname     = "app.terraform.io"
    organization = "KonigFranxx-Gmhb"

    workspaces {
      name = "infraestructure"
    }
  }

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.1"
    }
    # Añadiendo un proveedor de Docker para Prometheus
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}



# Crear el volumen de disco para el sistema operativo
resource "libvirt_volume" "debian_image" {
  name   = "debian-12-generic-amd64.qcow2"
  pool   = "default"
  source = "https://cloud.debian.org/images/cloud/bookworm/20230531-1397/debian-12-generic-amd64-20230531-1397.qcow2"
  format = "qcow2"
}

# Crear un volumen de cloud-init para la configuración inicial
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "cloud-init.iso"
  pool           = "default"

 user_data = <<-EOF
    #cloud-config
    users:
      - name: lucas
        passwd: 'password'
        lock_passwd: false
        groups: sudo
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    EOF
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
    addresses = ["192.168.100.130"]  # Fijar IP estática

data "template_file" "cloudinit" {
  template = file("./cloudinit.yaml")
}

resource "libvirt_cloudinit_disk" "common_init" {
  name           = "cloud-init.iso"
  user_data      = data.template_file.cloudinit.rendered
  pool           = "default"
}

  }
}
