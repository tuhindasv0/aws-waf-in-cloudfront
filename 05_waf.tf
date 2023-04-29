resource "aws_wafv2_ip_set" "ip_blacklist" {
  name               = "ip-blacklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["202.8.112.100/32"]
}

resource "aws_wafv2_web_acl" "poc-firewall" {
  name = "poc-firewall"

  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "ip-blacklist"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_blacklist.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlacklistedIP"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Allowed"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "poc-waf-association" {
  resource_arn = aws_lb.poc-lb.arn
  web_acl_arn  = aws_wafv2_web_acl.poc-firewall.arn

}

# TODO : Cloudwatch log
# Fetch origin Ip