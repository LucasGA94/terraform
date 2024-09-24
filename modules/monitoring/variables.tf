variable "libvirt_uri" {
  description = "URI para conectar al hipervisor KVM"
  type        = string
  default     = "qemu:///system"
}

variable "libvirt_pool" {
  description = "Nombre del pool de almacenamiento en libvirt"
  type        = string
  default     = "default"
}

variable "debian_image_name" {
  description = "Nombre del disco de la imagen de Debian"
  type        = string
  default     = "debian-12-generic-amd64-20230531-1397.qcow2"
}

variable "debian_image_size" {
  description = "Tamaño del disco de Debian en bytes"
  type        = number
  default     = 10 * 1024 * 1024 * 1024  # 10 GB
}

variable "debian_iso_name" {
  description = "Nombre del volumen de la ISO de Debian"
  type        = string
  default     = "debian-11.iso"
}

variable "debian_iso_source" {
  description = "Ruta a la ISO de Debian"
  type        = string
  default     = "/home/lucas/debian-12.7.0-amd64-DVD-1.iso"
}

variable "vm_name" {
  description = "Nombre de la máquina virtual"
  type        = string
  default     = "debian-vm"
}

variable "vm_memory" {
  description = "Memoria asignada a la máquina virtual en MB"
  type        = number
  default     = 1024  # 1 GB
}

variable "vm_vcpu" {
  description = "Número de CPUs virtuales asignadas a la máquina virtual"
  type        = number
  default     = 1
}

variable "network_name" {
  description = "Nombre de la red a la que se conecta la VM"
  type        = string
  default     = "default"
}

variable "prometheus_port" {
  description = "Puerto en el que se expondrá Prometheus"
  type        = number
  default     = 9090
}
