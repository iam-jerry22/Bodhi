resource "aws_s3_bucket" "pipelines_bucket" {
  bucket = "${var.cluster_name}-pipelines-bucket"
  acl    = "private"

  tags = {
    Name        = "${var.cluster_name}-pipelines-bucket"
    Environment = var.env
  }
}


resource "aws_s3_bucket" "mlflow_bucket" {
  bucket = "${var.cluster_name}-mlfow-bucket"
  acl    = "private"

  tags = {
    Name        = "${var.cluster_name}-mlfow-bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "mlflow_bucket" {
  bucket = aws_s3_bucket.mlflow_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


resource "aws_s3_bucket_public_access_block" "pipelines_bucket" {
  bucket = aws_s3_bucket.pipelines_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


