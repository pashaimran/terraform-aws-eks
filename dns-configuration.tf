# resource "aws_route53_record" "grafana" {
#   zone_id = "Z0760403ON7QKAV8Y6YO"
#   name    = "grafana.monitoring.com"
#   type    = "A"
#   ttl     = 300

#   # Assuming helm_release.nginx_ingress outputs the IP address directly
#   records = [helm_release.nginx_ingress]
# }

# resource "aws_route53_record" "prometheus" {
#   zone_id = "Z0760403ON7QKAV8Y6YO"
#   name    = "prometheus.monitoring.com"
#   type    = "CNAME"
#   ttl     = 300

#   # Assuming helm_release.nginx_ingress outputs the IP address directly
#   records = [helm_release.nginx_ingress]
# }