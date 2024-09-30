terraform {
  cloud {
    organization = "your-org-name"

    workspaces {
      name = "aws-managed-prometheus"
    }
  }
}
