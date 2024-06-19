variable "cidr" { default = "10.0.0.0/16" }
variable "private_subnets_cidr_blocks" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}
variable "public_subnets_cidr_blocks" {
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable "region" { default = "eu-west-2" }
variable "access-key" {}
variable "secret-key" {}

variable "chart_version" { default = "4.9.0" }
variable "namespace" { default = "ingress-nginx" }
variable "repo" { default = "https://kubernetes.github.io/ingress-nginx" }
# variable "values" { default = "./route53/ingress-values.yaml" }

