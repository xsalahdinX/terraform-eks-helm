 module "gatway-s3" {
  source = "github.com/xsalahdinX/terraform-modules//endpoint-gatway"
  region = "us-east-1"
  bucket_name = ["xsalahdinX-s3"]
  depends_on = [ module.test-s3]

 }