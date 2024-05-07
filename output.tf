output "s3_bucket_arn" {
  value = aws_s3_bucket.sbks3_2.arn
}

output "kms_key_arn" {
  value = aws_kms_key.SBKKMS.arn
}
