resource "aws_waf_ipset" "ipset" {
  name = "sre-ip-space"

  ip_set_descriptors {
    type  = "IPV4"
    value = "192.168.0.0/16"
  }
}

resource "aws_waf_rule" "wafrule" {
  name        = "sre-waf-rule"
  metric_name = "SREWAFRULE"

  predicates {
    type    = "IPMatch"
    negated = false
    data_id = aws_waf_ipset.ipset.id
  }

  depends_on = [aws_waf_ipset.ipset]
}

resource "aws_waf_web_acl" "waf_acl" {
  name        = "sre-waf-acl"
  metric_name = "SREWAFACL"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "ALLOW"
    }
    priority = 1
    rule_id  = aws_waf_rule.wafrule.id
  }
  depends_on = [
    aws_waf_ipset.ipset,
    aws_waf_rule.wafrule,
  ]
}



resource "aws_cloudfront_distribution" "example" {

  origin {
    domain_name = aws_alb.application_load_balancer.dns_name
    origin_id   = "sre-frontend"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
    enabled = true
    web_acl_id = aws_waf_web_acl.waf_acl.id

 

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "sre-frontend"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

    restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

     depends_on = [
    aws_waf_web_acl.waf_acl, aws_lb_listener.listener,
    ]
}