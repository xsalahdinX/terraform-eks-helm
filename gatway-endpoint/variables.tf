variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type = set(string)
}


variable "region" {
  description = "The region of the S3 bucket"
  default     = "us-east-1"

}