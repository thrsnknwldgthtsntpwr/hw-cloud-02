resource "yandex_storage_bucket" "nikiforov-roman-2025-07-27" {
  bucket = "nikiforov-roman-2025-07-27"
  anonymous_access_flags {
    read = true
    list = false
    config_read = false
  }
  folder_id = "b1g8idjusu652hr2ocgh"
  default_storage_class = "ICE"
}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.nikiforov-roman-2025-07-27.bucket
  key    = "image.png"
  source = "./Screenshot_1.png"
}