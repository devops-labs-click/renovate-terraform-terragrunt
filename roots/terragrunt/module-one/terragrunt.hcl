terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=2.78.0"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = ""
  api_key    = ""   # usually prefixed with 'NRAK'
  region     = "US" # Valid regions are US and EU
}
EOF
}

generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 3.0"
        }
        newrelic = {
          source  = "newrelic/newrelic"
          version = "~> 2.0"
        }
        github = {
          source  = "integrations/github"
          version = "~> 4.31.0"
        } 
      }
    }
EOF
}

# Indicate the input values to use for the variables of the module.
inputs = {
  name = "my-vpc-terragrunt"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
