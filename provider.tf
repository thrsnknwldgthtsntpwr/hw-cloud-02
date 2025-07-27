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

resource "yandex_iam_service_account" "lamp-sa" {
     name        = "lamp-sa"
     description = "Сервисный аккаунт для hw-cloud-02"
   }

resource "yandex_resourcemanager_folder_iam_member" "lamp-sa" {
  folder_id   = "b1g8idjusu652hr2ocgh"
  role        = "admin"
  member      = "serviceAccount:${yandex_iam_service_account.lamp-sa.id}"
}

variable "yc_token" {
  type = string
  sensitive = true
}