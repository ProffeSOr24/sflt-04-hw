terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.8"
}

provider "yandex" {
  cloud_id  = "b1gej2n3q137s29reqfq"
  folder_id = "b1glrt0ti95j5scdt7e3"
  zone = "ru-central1-a"
  service_account_key_file = file("~/.authorized_key.json")
}
