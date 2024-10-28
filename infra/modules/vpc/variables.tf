variable "vpc_cidr" {
  description = "A cidr block for the vpc"
  default     = "10.0.0.0/16"
  type        = string
}

variable "subnet_cidr" {
  description = "A cidr block for the subnet"
  default     = "10.0.10.0/24"
  type        = string

}
variable "availability_zone" {
  description = "the availability zone to be selected"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
