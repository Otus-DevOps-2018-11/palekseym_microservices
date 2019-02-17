output "app_external_ip" {
  value = "${module.docker-instance.docker_external_ip}"
}
