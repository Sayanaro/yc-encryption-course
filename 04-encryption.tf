# Creating symmetric KMS Key
resource "yandex_kms_symmetric_key" "k8s-key" {
  name              = "${var.kms_key_name}"
  default_algorithm = "AES_256"
}

# SA role binding for KMS Key
resource "yandex_kms_symmetric_key_iam_binding" "encrypterDecrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.k8s-key.id
  role             = "kms.keys.encrypterDecrypter"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_service_sa.id}",
  ]
}

#Create ssh key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "pt_key.pem"
  file_permission = "0600"
}
