variable "external_lb_name" {
  type        = string
  description = "Name of the internal load balancer for trust traffic"
}
variable "public_ip_name" {
  type        = string
  description = "Name of Public IP address"
}
variable "availability_set_name" {
  type        = string
  description = "Name of the availability set"
}
variable "management_nic_name" {
  type        = string
  description = "Name of the management nic"
}

variable "number_of_firewalls" {
  type        = number
  default     = 2
  description = "number of firewalls to deploy with Terraform"
}

# variable "data_nic_name" {
#   type        = string
#   description = "Name of the data nic"
# }
variable "trust_nic_name" {
  type        = string
  description = "Name of the trust nic"
}
variable "untrust_nic_name" {
  type        = string
  description = "Name of the untrust nic"
}

variable "firewall_name" {
  type        = string
  description = "Name of the firewall"
}

# variable "custom_data" {
#   type        = string
#   description = "Palo Alto GWLB settings, base64 encode them before the variable"
#   default     = "cGx1Z2luLW9wLWNvbW1hbmRzPWF6dXJlLWd3bGItaW5zcGVjdDplbmFibGUraW50ZXJuYWwtcG9ydC0yMDAwK2V4dGVybmFsLXBvcnQtMjAwMStpbnRlcm5hbC12bmktODAwK2V4dGVybmFsLXZuaS04MDE="
#   # plugin-op-commands=azure-gwlb-inspect:enable+internal-port-2000+external-port-2001+internal-vni-800+external-vni-801
# }

variable "username" {
  description = "username for the palo firewall"
  type        = string
  default     = "paloadmin"
}

variable "password" {
  description = "Password for the palo firewalls"
  type        = string
}

variable "sku" {
  description = "Palo Alto Marketplace SKU (bundle1,bundle2,byol)"
  type        = string
}
variable "palo_version" {
  description = "Palo Alto software version"
  type        = string

}
variable "internal_lb_name" {
  type        = string
  description = "Name of the internal load balancer for trust traffic"
}
variable "mgmt_table_name" {
  type        = string
  description = "Name of Management Route Table"
}
variable "untrust_table_name" {
  type        = string
  description = "Name of Untrust Route Table"
}
variable "trust_table_name" {
  type        = string
  description = "Name of Trust Route Table"
}
