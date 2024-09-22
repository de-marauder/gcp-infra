# create variables for the variables
variable "project_id" {
  description = "General project id"
  type        = string
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

variable "db_user" {
  description = "Database password"
  default = "root"
}
variable "db_name" {
  description = "Database password"
  default = "test_db"
}
variable "db_password" {
  description = "Database password"
  default = "password"
}