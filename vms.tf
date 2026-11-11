# Найти актуальный образ Ubuntu 24.04
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index}"
  hostname    = "web-${count.index}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    user-data = file("./cloud-init.yml")
  }

  scheduling_policy {
    preemptible = true
  }
}

output "web_ips" {
  value = yandex_compute_instance.web[*].network_interface.0.nat_ip_address
}
