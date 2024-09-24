output "vm_name" {
  description = "Nombre de la máquina virtual creada"
  value       = libvirt_domain.debian_vm.name
}

output "debian_disk_name" {
  description = "Nombre del disco de la imagen de Debian"
  value       = libvirt_volume.debian_image.name
}

output "debian_iso_name" {
  description = "Nombre del volumen de la ISO de Debian"
  value       = libvirt_volume.debian_iso.name
}
output "prometheus_url" {
  description = "URL de acceso a Prometheus"
  value       = "http://localhost:${docker_container.prometheus.ports[0].external}"
}