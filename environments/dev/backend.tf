terraform {

  backend "s3" {

    bucket = "tfstate-sudheer-001"

    key = "dev/terraform.tfstate"

    region = "us-east-1"

    dynamodb_table = "tfstate-lock"

    encrypt = true
  }
}
