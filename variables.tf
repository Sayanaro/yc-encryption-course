variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "k8s-network"
}

variable "net_cidr" {
  description = "Subnet structure primitive"
  type = list(object({
    name = string,
    zone = string,
    prefix = string
  }))

  default = [
    { name = "k8s-subnet-a", zone = "ru-central1-a", prefix = "10.30.1.0/24" },
    { name = "k8s-subnet-b", zone = "ru-central1-b", prefix = "10.30.2.0/24" },
    { name = "k8s-subnet-b", zone = "ru-central1-c", prefix = "10.30.3.0/24" },
  ]

  validation {
    condition = length(var.net_cidr) >= 1
    error_message = "At least one Subnet/Zone should be used."
  }
}

variable "zone" {
  type    = string
  default = "ru-central1-b"
}

variable "public_ip" {
  type    = bool
  default = true
}

variable "platform_id" {
  type    = string
}

variable "cores" {
  type    = number
}

variable "memory" {
  type    = number
}

variable "disk_size" {
  type    = number
}

variable "disk_type" {
  type    = string
}

#-----------------------------------------
variable "k8s_version" {
  description = "K8s version"
  type = string
}

variable "kms_key_name" {
  type = string
  default = "k8s-key"
}

variable "k8s_service_sa_name" {
  type = string
  default = "lab-k8s-service-sa"
}

variable "k8s_node_sa_name" {
  type = string
  default = "lab-k8s-node-sa"
}

variable "k8s_puller" {
  type = string
  default = "lab-k8s-node-sa"
}

variable "FOLDERID" {
  type = string
}