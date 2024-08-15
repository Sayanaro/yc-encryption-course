#Create lab-k8s VM

resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name = "k8s-secrets-cluster"
  network_id = "${yandex_vpc_network.network-lab-k8s.id}"
  cluster_ipv4_range = "10.96.0.0/16"
  service_ipv4_range = "10.112.0.0/16"
  
  master {
    version = "${k8s_version}"

    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.lab-k8s-subnet[1].id
    }

    public_ip = var.public_ip

    security_group_ids = [
      yandex_vpc_security_group.k8s-main-sg.id,
      yandex_vpc_security_group.k8s-master-whitelist.id
    ]
    
    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "00:00"
        duration   = "3h"
      }
    }
    
  }

  service_account_id      = "${yandex_iam_service_account.k8s_service_sa.id}"
  node_service_account_id = "${yandex_iam_service_account.k8s_node_sa.id}"

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = "${yandex_kms_symmetric_key.k8s-key.id}"
  }
}



resource "yandex_kubernetes_node_group" "worker-node" {
  cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
  name       = "worker-nodes"
  version    = "1.27"

  instance_template {
    platform_id = var.platform_id
    network_interface {
      nat                = true
      subnet_ids         = yandex_vpc_subnet.lab-k8s-subnet[1].id
      security_group_ids = [
        yandex_vpc_security_group.k8s-main-sg.id,
        yandex_vpc_security_group.k8s-nodes-ssh-access.id,
        yandex_vpc_security_group.k8s-public-services.id
      ]
    }

    resources {
      memory = var.cores
      cores  = var.memory
    }

    boot_disk {
      type = var.disk_type
      size = var.disk_size
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "sunday"
      start_time = "00:00"
      duration   = "4h30m"
    }
  }
}

