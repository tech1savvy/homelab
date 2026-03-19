variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}

variable "node_name" {
  description = "The name for the node"
  type        = string
}

variable "public_key" {
  description = "The public key for SSH access"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.medium"
}

variable "architecture" {
  description = "The CPU architecture (x86_64 or arm64)"
  type        = string
  default     = "x86_64"
}

variable "instance_state" {
  description = "The desired state of the instance (running or stopped)"
  type        = string
  default     = "running"
}

variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 20
}
