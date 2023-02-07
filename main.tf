
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
    repository = [{
        name = "terraform_test_01",
        topics = ["test-01"]
    },
    {
        name = "terraform_test_02"
        topics = ["test-02"]
    }]
}


output "repos" {
  value = module.repositories.repositories
}
