# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.

 ```
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
 ```
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
```
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
```
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
