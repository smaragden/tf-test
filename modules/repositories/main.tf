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

resource "github_repository" "repository" {
    for_each = {
        for repo in var.repository:
        repo.name => repo
    }
    name = each.value.name
    topics = distinct(concat(each.value.topics, var.default_topics))
}

output "repositories" {
  value = var.repository
}
