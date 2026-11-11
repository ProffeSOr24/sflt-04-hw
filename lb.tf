# Целевая группа: между кем распределять трафик
resource "yandex_lb_target_group" "web" {
  name = "sflt-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.web[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.web[1].network_interface.0.ip_address
  }
}

# Сетевой балансировщик нагрузки
resource "yandex_lb_network_load_balancer" "lb" {
  name = "sflt-nlb"

  listener {
    name        = "http"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
