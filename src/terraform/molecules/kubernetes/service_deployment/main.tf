resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"

    labels {
      name = "${var.name}"
    }
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels {
        name = "${var.name}"
      }
    }

    template {
      metadata {
        labels {
          name = "${var.name}"
        }
      }

      spec {
        container {
          image = "${var.image}"
          name  = "${var.name}"

          resources = ["${var.resources}"]
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      name = "${var.name}"
    }

    port {
      port = "${var.port}"
    }

    type = "${var.service_type}"
  }
}
