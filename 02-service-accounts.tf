# Creating Service Accounts

resource "yandex_iam_service_account" "k8s_service_sa" {
  name        = "${var.k8s_service_sa_name}"
}

resource "yandex_iam_service_account" "k8s_node_sa" {
  name        = "${var.k8s_node_sa_name}"
}

resource "yandex_iam_service_account" "k8s_puller" {
  name        = "${var.k8s_puller}"
}

# Configure Access Bindings

resource "yandex_resourcemanager_folder_iam_binding" "service_sa_bindings" {
  folder_id = "${FOLDERID}"

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_service_sa.id}",
    "serviceAccount:${yandex_iam_service_account.k8s_puller.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_pullers_bindings" {
  folder_id = "${FOLDERID}"

  role = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_node_sa.id}",
    "serviceAccount:${yandex_iam_service_account.k8s_puller.id}",  ]
}
