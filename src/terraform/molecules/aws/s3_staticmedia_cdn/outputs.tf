output "cdn_domain" {
  value = "${aws_cloudfront_distribution.static_media.domain_name}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.static_media.bucket}"
}

output "aws_access_key_id" {
  value = "${aws_iam_access_key.key.id}"
}

output "aws_access_secret_key" {
  value = "${aws_iam_access_key.key.secret}"
}
