### Variables for Web VM

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for Ubuntu compute image"
}

#variable "vm_web_name" {
#  type        = string
#  default     = "netology-develop-platform-web"
#  description = "Name of the web compute instance"
#}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Hardware platform ID for the web instance"
}

#variable "vm_web_cores" {
#  type        = number
#  default     = 2
#  description = "Number of CPU cores for web VM"
#}

#variable "vm_web_memory" {
#  type        = number
#  default     = 1
#  description = "RAM size in GB for web VM"
#}

#variable "vm_web_core_fraction" {
#  type        = number
#  default     = 5
#  description = "Baseline CPU performance in percent for web VM"
#}


### Variables for DB VM

variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for DB Ubuntu compute image"
}

#variable "vm_db_name" {
#  type        = string
#  default     = "netology-develop-platform-db"
#  description = "Name of the DB compute instance"
#}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Hardware platform ID for the DB instance"
}

#variable "vm_db_cores" {
#  type        = number
#  default     = 2
#  description = "Number of CPU cores for DB VM"
#}

#variable "vm_db_memory" {
#  type        = number
#  default     = 2
#  description = "RAM size in GB for DB VM"
#}

#variable "vm_db_core_fraction" {
#  type        = number
#  default     = 20
#  description = "Baseline CPU performance in percent for DB VM"
#}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Availability zone for DB VM"
}

variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "Subnet CIDR for DB zone-b"
}


### Unified resource map for all VMs

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
  description = "Hardware resource profiles for all VMs"
}

### Unified metadata for all VMs

variable "metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
  }
  description = "Common metadata configuration for all VMs"
}
