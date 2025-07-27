resource "yandex_vpc_network" "vpc-01" {
  name = "vpc-01"
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id = yandex_vpc_network.vpc-01.id
}