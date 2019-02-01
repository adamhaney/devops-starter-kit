resource "aws_s3_bucket" "static_media" {
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}"

  logging {
    target_bucket = "${var.logging_bucket}"
    target_prefix = "${var.bucket_name}-accesslog"
  }

  cors_rule {
    allowed_headers = ["*", "Authorization"]
    allowed_methods = ["GET"]
    max_age_seconds = "3000"
    allowed_origins = ["*"]
  }

  tags {
    costcenter = "${var.costcenter}"
    project    = "${var.project}"
  }
}

resource "aws_iam_user" "service_user" {
  name = "${var.service_name}"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.service_user.name}"
}

# Policy Adapted from: https://stackoverflow.com/a/19720722
# and https://gist.github.com/rockymeza/6157069 because
# apparently django-storages can't document what permissions it needs
resource "aws_iam_user_policy" "bucket_policy" {
  name = "${aws_iam_user.service_user.name}_user_policy"
  user = "${aws_iam_user.service_user.name}"

  policy = <<IAM
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
    
      "Action":[
        "s3:ListAllMyBuckets"
      ],
      "Resource":"arn:aws:s3:::*"
    },
    {
      "Sid": "AllowListObjects",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions"
      ],
      "Resource": "${aws_s3_bucket.static_media.arn}"
    },
    {
      "Sid": "AllowObjectsCRUD",
      "Effect": "Allow",
      "Action": [
        "s3:*Object*",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "${aws_s3_bucket.static_media.arn}/*"
    }
  ]
}
  IAM
}

resource "aws_cloudfront_distribution" "static_media" {
  origin {
    domain_name = "${aws_s3_bucket.static_media.bucket_regional_domain_name}"
    origin_id   = "${var.service_name}-origin"
  }

  enabled = true

  logging_config {
    bucket = "${aws_s3_bucket.static_media.bucket_domain_name}"
    prefix = "${var.logging_bucket}"
  }

  origin {
    origin_id   = "S3-${var.bucket_name}"
    domain_name = "${aws_s3_bucket.static_media.bucket_domain_name}"
  }

  ordered_cache_behavior {
    path_pattern           = "*.woff"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward           = "none"
        whitelisted_names = []
      }

      headers = [
        "Access-Control-Request-Method",
        "Access-Control-Request-Headers",
        "Origin",
      ]
    }
  }

  ordered_cache_behavior {
    path_pattern    = "/admin/fonts/Roboto-Bold-webfont.woff"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward           = "none"
        whitelisted_names = []
      }

      headers = [
        "Access-Control-Request-Method",
        "Access-Control-Request-Headers",
        "Origin",
      ]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = "86400"
    max_ttl                = "31536000"

    forwarded_values {
      query_string = ""

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
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
