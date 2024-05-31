# Bucket S3
resource "aws_s3_bucket" "cris_johan_project" {
  bucket = "cris-johan-project"

  tags = {
    Name = "cris_johan_project"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership_controls" {
  bucket = aws_s3_bucket.cris_johan_project.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership_controls]

  bucket = aws_s3_bucket.cris_johan_project.id
  acl    = "private"
}