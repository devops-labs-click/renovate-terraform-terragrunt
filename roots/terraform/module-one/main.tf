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

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "2.78.0"
  name            = "my-vpc-terraform"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
