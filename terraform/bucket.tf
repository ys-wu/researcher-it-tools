resource "aws_s3_bucket" "b" {
  bucket = "researcher-it-tools.yushengwu.com"
}

resource "aws_s3_object" "object" {
  depends_on = [aws_s3_bucket.b]

  bucket       = aws_s3_bucket.b.id
  key          = "index.html"
  source       = "../reveal.js/index.html" 
  content_type = "text/html"
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
  depends_on = [aws_s3_object.object]

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
