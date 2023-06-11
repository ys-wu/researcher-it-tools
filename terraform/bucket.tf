resource "aws_s3_bucket" "b" {
  bucket = "researcher-it-tools.yushengwu.com"
}

locals {
  mime_types = jsondecode(file("mime.json"))
}

resource "aws_s3_object" "index" {
  depends_on = [aws_s3_bucket.b]

  bucket       = aws_s3_bucket.b.id
  key          = "index.html"
  source       = "../reveal.js/index.html" 
  content_type = lookup(local.mime_types, ".html", null)
}

resource "aws_s3_object" "dist_object" {
  depends_on = [aws_s3_bucket.b]

  for_each     = fileset("../reveal.js/dist/", "**/*")
  bucket       = aws_s3_bucket.b.id
  key          = "dist/${each.value}"
  source       = "../reveal.js/dist/${each.value}"
  content_type = lookup(local.mime_types, can(regex("\\.[^.]+$", each.value)) ? regex("\\.[^.]+$", each.value) : "", null)
}

resource "aws_s3_object" "plugin_object" {
  depends_on = [aws_s3_bucket.b]

  for_each     = fileset("../reveal.js/plugin/", "**/*.js")
  bucket       = aws_s3_bucket.b.id
  key          = "plugin/${each.value}"
  source       = "../reveal.js/plugin/${each.value}"
  content_type = lookup(local.mime_types, can(regex("\\.[^.]+$", each.value)) ? regex("\\.[^.]+$", each.value) : "", null)
}

resource "aws_s3_bucket_public_access_block" "b_block" {
  depends_on = [aws_s3_bucket.b]

  bucket = aws_s3_bucket.b.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  depends_on = [aws_s3_object.index]

  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "b_policy" {
  depends_on = [
    aws_s3_bucket.b,
    aws_s3_bucket_website_configuration.website_config,
  ]

  bucket = aws_s3_bucket.b.id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
  "Sid":"PublicReadForGetBucketObjects",
      "Effect":"Allow",
    "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::researcher-it-tools.yushengwu.com/*"
      ]
    }
  ]
}
POLICY
}
