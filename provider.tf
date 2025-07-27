terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
  token  = var.yc_token
  cloud_id  = "b1gmrdbulmjk5vov6tbl"
  folder_id = "b1g8idjusu652hr2ocgh"
}

variable "yc_token" {
  type = string
  sensitive = true
}