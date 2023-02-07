variable "default_topics" {
    type = list(string)
}

variable "repository" {
    type = list(object(
        {
            name = string
            topics = list(string)
        }
    ))
}



locals {
  enriched_repositories = {
        for index, repo in var.repository:
        repo.name => merge(repo, {
            topics = distinct(concat(repo.topics, var.default_topics))
        })
    }
}

resource "github_repository" "repository" {
    for_each = local.enriched_repositories
    name = each.value.name
    topics = each.value.topics
}

output "repositories" {
  value = local.enriched_repositories
}
