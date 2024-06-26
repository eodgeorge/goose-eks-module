data "aws_route53_zone" "ingress-route53_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "dns_records" {
  for_each = toset(var.subdomains)

  zone_id = data.aws_route53_zone.ingress-route53_zone.zone_id
  name    = "${each.value}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = var.nginx_ingress_lb_dns != "" ? [var.nginx_ingress_lb_dns] : ["placeholder-value"]
}




# resource "aws_route53_record" "record" {
#   zone_id = data.aws_route53_zone.ingress-route53_zone.zone_id
#   name    = "ingress-nginx.${var.domain_name}" "argocd.${var.domain_name}"
#   type    = "CNAME"
#   ttl     = 300
#   records = var.nginx_ingress_lb_dns != "" ? [var.nginx_ingress_lb_dns] : ["placeholder-value"]
# }


# resource "aws_acm_certificate" "acm_certificate" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "validation_record" {
#   for_each = {
#     for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.ingress-route53_zone.zone_id
# }


# resource "aws_acm_certificate_validation" "acm_certificate_validation" {
#   certificate_arn         = aws_acm_certificate.acm_certificate.arn
#   validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
    
#     timeouts {
#     create = "8m"
#   }
#   #  depends_on = [aws_route53_record.record]
# }

