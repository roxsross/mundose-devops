module "terraform-aws-static-s3" {
  source      = "git::git@github.com:roxsross/mundose-devops.git//modules/terraform-aws-static-s3?ref=devops2403"
  bucket_name = "prueba.demo.backend.mundose.com"


}