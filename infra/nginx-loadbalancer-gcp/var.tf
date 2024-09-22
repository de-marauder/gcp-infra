# create variables for the variables
variable "project_id" {
  description = "General project id"
  type        = string
  default     = "shortlet-app-434213"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "List of GCP zones"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "subnet_count" {
  description = "Number of subnet to create"
  type        = number
  default     = 1
}

