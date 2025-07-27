resource "yandex_compute_instance_group" "lamp_group" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.lamp-sa
  ]
  name = "lamp-group"
  service_account_id = yandex_iam_service_account.lamp-sa.id
  instance_template {
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 1
      core_fraction = 20
    }
    scheduling_policy {
      preemptible = true
    }
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat = true
    }
    metadata = {
      user-data = <<-EOF
        #!/bin/bash
        echo '<html><body><img src="https://storage.yandexcloud.net/${yandex_storage_bucket.nikiforov-roman-2025-07-27.bucket}/${yandex_storage_object.image.key}"></body></html>' > /var/www/html/index.html
        systemctl restart apache2
      EOF
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = ["ru-central1-a"]
  }
  deploy_policy {
    max_unavailable = 3
    max_expansion = 0
  }
  health_check {
    http_options {
      path = "/"
      port = 80
    }
  }
}