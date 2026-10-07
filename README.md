# Задание 1
<img width="1800" height="142" alt="image" src="https://github.com/user-attachments/assets/b834cb33-2c4f-4619-9e6e-38037ea8a4f8" />
<img width="779" height="70" alt="image" src="https://github.com/user-attachments/assets/ee9788e3-2e07-4672-86c6-533565ea82be" />

суть синтаксических ошибок в коде:
1) в "platform_id = "standart-v4" была ошибка: t вместо d. а также было указано количество ядер, равное 1, однако на деле необходимо значение cores=2.
2) preemptible = true - прерываемая ВМ, останавливается через 24 часа, сильно экономит деньги. core_fraction = 5 - допустимая доля процессорного времени (5%) - максимально снижает затраты на аренду вычислительных ресурсов
# Задание 2
<img width="1452" height="679" alt="image" src="https://github.com/user-attachments/assets/3631db53-5bac-4ad9-9536-871216cd43bc" />
поменял значения в вериблс.тф и затем в мэин.тф. Терраформ план показал, что изменений нет
# Задание 3
<img width="955" height="176" alt="image" src="https://github.com/user-attachments/assets/cda24050-6397-403b-9ba9-145023577208" />
<img width="666" height="192" alt="image" src="https://github.com/user-attachments/assets/0bd98c21-4848-4ea6-a04d-170c5cdae2b1" />
<img width="1144" height="301" alt="image" src="https://github.com/user-attachments/assets/4c5d6ea0-7113-4474-94c2-d425feaa5065" />

# Задание 4
<img width="1355" height="512" alt="image" src="https://github.com/user-attachments/assets/d58588e1-6438-4611-b090-31971baed747" />
<img width="984" height="337" alt="image" src="https://github.com/user-attachments/assets/5bc9a1b0-49cc-45c1-a645-cd77b0ca7ab2" />
<img width="857" height="234" alt="image" src="https://github.com/user-attachments/assets/fbafd656-ea8a-4dec-8287-9a91127682c6" />

# Задание 5
<img width="1460" height="362" alt="image" src="https://github.com/user-attachments/assets/fc69009e-ee03-4425-be90-ac8d8628d09e" />

# Задание 6
<img width="1485" height="357" alt="image" src="https://github.com/user-attachments/assets/b944f390-eaf0-4d9e-96ec-f341d35582e9" />


# код

main.tf: 
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_name
  platform_id = var.vm_web_platform_id

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

### Subnet for Zone B
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_cidr
}

### DB VM
resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone

  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```

variables.tf:

```
###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}
```

vms_platform.tf:

```
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
```

locals.tf:

```
locals {
  project  = "netology"
  env      = "develop"
  platform = "platform"

  vm_web_name = "${local.project}-${local.env}-${local.platform}-web"
  vm_db_name  = "${local.project}-${local.env}-${local.platform}-db"
}
```

outputs.tf:

```
output "vms_info" {
  description = "Information about created instances"
  value = {
    web = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.fqdn
    }
    db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform_db.fqdn
    }
  }
}
```
