variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "network_interface_id" {
  description = "The ID of the pre-created network interface to attach"
  type        = string
}

variable "key_name" {
  description = "The key name for SSH access"
  type        = string
}

variable "instance_name" {
  description = "The name for the instance"
  type        = string
}

variable "instance_state" {
  description = "The desired state of the instance (running or stopped)"
  type        = string
  default     = "running"
}

variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 8
}
