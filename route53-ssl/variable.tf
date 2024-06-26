# variable "domain_name" {}
variable "a_domain_name" {}
variable "nginx_ingress_lb_dns" {
  description = "DNS name of the Nginx Ingress Load Balancer"
  type        = string
}
variable "domain_name" {
  type = string
}

variable "subdomains" {
  type    = list(string)
}
