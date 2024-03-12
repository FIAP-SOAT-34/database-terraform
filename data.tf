data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "tech-challenge-grupo34"
    key    = "tech-challenge/terraform.tfstate"
    region = "us-east-1"
  }
}