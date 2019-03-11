variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west2"
}

variable zone {
  description = "Zone for creat instance"
  default     = "europe-west2-a"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-docker"
}

variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
