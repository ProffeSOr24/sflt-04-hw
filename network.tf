# Облачная сеть
resource "yandex_vpc_network" "net" {
  name = "sflt-net"
}

# Подсеть в зоне ru-central1-a
resource "yandex_vpc_subnet" "subnet" {
  name           = "sflt-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

# Группа безопасности (фаервол) для веб-серверов
resource "yandex_vpc_security_group" "web" {
  name       = "sflt-web-sg"
  network_id = yandex_vpc_network.net.id

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Healthcheck балансировщика"
    protocol          = "TCP"
    port              = 80
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    description    = "Весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
