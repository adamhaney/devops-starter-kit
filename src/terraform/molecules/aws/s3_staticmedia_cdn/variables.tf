variable "bucket_name" {
  type        = "string"
  description = "The name of the bucket to create for storing static/media files"
}

variable "service_name" {
  type        = "string"
  description = "The service name that 'owns' this content, this will be used to name the role/policy/key that is returned to allow access to this bucket"
}

variable "project" {
  type        = "string"
  description = "The project associated with these resources (used for tagging)"
}

variable "costcenter" {
  type        = "string"
  description = "Cost center to associate with these resources used for tagging and resource accounting"
  default     = "content-distribution"
}

variable "bucket_acl" {
  type    = "string"
  default = "private"
}

variable "logging_bucket" {
  type = "string"
}
