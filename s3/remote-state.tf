terraform {
  backend "remote" {
    organization = "your-org-name"
    workspaces {
      prefix = "s3-"
    }
  }
}