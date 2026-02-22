variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be created"
  type        = string
}

variable "security_group_ids" {
  description = "The security group IDs to associate with the instance"
  type        = list(string)
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

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}
