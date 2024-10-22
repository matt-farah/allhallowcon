# resource "aws_route53_zone" "zone_1512_ninja" {
#   name = "1512.ninja"
# }

# resource "aws_route53_record" "a_1512_ninja" {
#   zone_id = aws_route53_zone.zone_1512_ninja.id
#   name    = "1512.ninja"
#   type    = "A"

#   ttl = 300

#   records = [
#     "99.117.23.45",
#   ]
# }

import {
  to = aws_route53domains_registered_domain.allhallowcon_com
  id = "allhallowcon.com"
}

resource "aws_route53domains_registered_domain" "allhallowcon_com" {
    admin_privacy       = true
    auto_renew          = true
    billing_privacy     = true
    domain_name         = "allhallowcon.com"
    registrant_privacy  = true
    tech_privacy        = true
    transfer_lock       = false

    dynamic "name_server" {
        for_each = toset(aws_route53_zone.allhallowcon_com.name_servers)
        content {
            glue_ips = []
            name     = name_server.value
        }
    }
}

resource "aws_route53_zone" "allhallowcon_com" {
  name = "allhallowcon.com"
}

# resource "aws_route53_record" "a_1512_link" {
#   zone_id = aws_route53_zone.zone_1512_link.id
#   name    = "allhallowcon.com"
#   type    = "A"

#   ttl = 300

#   records = [
#     "99.117.23.45",
#   ]
# }
