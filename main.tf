provider "aws" {
  region = "ap-northeast-2"  # Update with your desired AWS region
}

# Generate a random password
resource "random_password" "Sbk_password" {
  length           = 20  # Update with desired password length
  special          = true
  override_special = "_%@"
}

# Create an AWS KMS key
resource "aws_kms_key" "SBKKMS" {
  description             = "SBKKMS"
  deletion_window_in_days = 7
}

# Create an S3 bucket
resource "aws_s3_bucket" "sbks3_2" {
  bucket = "sbk-bucket1"  # Update with your desired bucket name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.SBKKMS.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "MyBucket"
    Environment = "Production"
  }
}

# Create a Secret Manager secret
resource "aws_secretsmanager_secret" "SBKSM" {
  name = "SBK-secret"
}

# Add the username and random password to the Secret Manager secret
resource "aws_secretsmanager_secret_version" "SM" {
  secret_id     = aws_secretsmanager_secret.SBKSM.id
  secret_string = jsonencode({
    username = "SBK",
    password = random_password.Sbk_password.result
  })
}