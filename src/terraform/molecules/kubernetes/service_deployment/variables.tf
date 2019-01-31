variable "name" {
  type        = "string"
  description = "The name of the service/deployment"
}

variable "namespace" {
  type        = "string"
  description = "The namespace where the service/deployment will be placed"
}

variable "image" {
  type        = "string"
  description = "The image to create the deployment from"
}

variable "replicas" {
  type        = "string"
  description = "The number of replica pods to have the deployment create"
  default     = "1"
}

variable "resources" {
  type        = "map"
  description = "The resources map to use when creating the deployment"

  default = {
    limits = [{
      cpu    = "0.5"
      memory = "512Mi"
    }]

    requests = [{
      cpu    = "250m"
      memory = "50Mi"
    }]
  }
}

variable "service_type" {
  type        = "string"
  description = "The type of service to create"
  default     = "ClusterIP"
}

variable "port" {
  type        = "string"
  description = "The port the service defines"
}
