terraform {
  backend "s3" {
    bucket = "self-hosted-577932"
    key    = "kubernates-cluster-terrform.tfstate"
    region = "us-east-1"
  }
}
