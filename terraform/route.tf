data "aws_route53_zone" "selected" {
  name         = "yushengwu.com."
  private_zone = false
}

resource "aws_route53_record" "record" {
  depends_on = [
    aws_s3_bucket.b,
    aws_s3_bucket_policy.b_policy,
  ]

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "researcher-it-tools.yushengwu.com"
  type    = "A"

  alias {
    name                   = "s3-website-us-east-1.amazonaws.com."
    zone_id                = aws_s3_bucket.b.hosted_zone_id
    evaluate_target_health = false
  }
}
