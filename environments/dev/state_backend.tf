terraform {
  backend "s3" {
    bucket       = "project-cob-terra-state"
    key          = "environments/dev/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}