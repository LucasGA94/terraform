terraform {
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

provider "libvirt" {
  uri = var.libvirt_uri
}

# Crear el volumen de disco para el sistema operativo
resource "libvirt_volume" "debian_image" {
  name   = var.debian_image_name
  pool   = var.libvirt_pool
  format = "qcow2"
  size   = var.debian_image_size
}

# Crear el volumen para la ISO de Debian
#resource "libvirt_volume" "debian_iso" {
 # name   = var.debian_iso_name
  #pool   = var.libvirt_pool
  #source = var.debian_iso_source
  #format = "raw"
#}

# Crear la máquina virtual para Debian
resource "libvirt_domain" "debian_vm" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  # CD-ROM con la ISO de Debian
 # disk {
  #  volume_id = libvirt_volume.debian_iso.id
  # scsi      = true
  #}

  # Disco de la máquina virtual
  disk {
    volume_id = libvirt_volume.debian_image.id
  }

  # Interfaz de red
  network_interface {
    network_name = var.network_name
  }
}

# Crear un contenedor Docker para Prometheus
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus:latest"

  ports {
    internal = 9090
    external = var.prometheus_port
  }

  volumes {
    host_path      = "${path.module}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  restart = "always"
}
