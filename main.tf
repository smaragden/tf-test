
provider "github" {}

terraform {
  required_providers {
    github = {
      version = "~> 4.6"
    }
  }
}

module "repositories" {
    source = "./modules/repositories"
    default_topics = ["test"]
    default_branch_protections = {
      main = {
          required_linear_history = true
      }
    }
    repository = [{
        name = "terraform_test_01",
        topics = ["test-01"],
        branch_protections = {
          dev = {
            required_linear_history = true
          }
        }
    },
    {
        name = "terraform_test_02"
        topics = ["test-02"]
    }]
}


output "branch_protections" {
  value = module.repositories.branch_protections
}
