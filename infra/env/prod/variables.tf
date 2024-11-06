variable "access_key" {
  default     = ""
  description = "Aws_access_key"
  type        = string
}

variable "secret_key" {
  default     = ""
  description = "Aws_secret_key"
  type        = string
}

variable "region" {
  description = "A cidr block for the vpc"
  default     = "eu-west-2"
  type        = string
}

variable "sec_grp_name" {
  description = "security group name"
}

variable "image" {
  description = "The image to deploy in the ecs task"
  default     = "merch7x/flask-blog:main"
}
