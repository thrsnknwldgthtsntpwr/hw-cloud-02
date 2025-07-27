resource "yandex_lb_target_group" "lamp_target_group" {
  name      = "lamp-target-group"
  region_id = "ru-central1"
  target {
    subnet_id  = yandex_vpc_subnet.public.id
    address    = yandex_compute_instance_group.lamp_group.instances[0].network_interface[0].ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lamp-lb" {
  name = "lamp-lb"
  
  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp_target_group.id
    
    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}