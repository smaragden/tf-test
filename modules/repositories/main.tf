variable "default_topics" {
    type = list(string)
}
variable "default_branch_protections" {
    type = map(
            object(
            {
                required_linear_history = bool
            }
        )
    )
}

variable "repository" {
    type = list(object(
        {
            name = string
            topics = list(string)
            branch_protections = optional(map(
                object(
                    {
                        required_linear_history = bool
                    }
                )
            ))
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

locals {
    branch_protections = {
        for b in flatten([
            for repo in var.repository : [
                for pattern, bp in merge(var.default_branch_protections, repo.branch_protections) : [
                    {
                        pattern = pattern
                        settings = bp
                        repository_id = github_repository.repository[repo.name].id
                    }
                ]
            ]
        ]) : "${b.repository_id}_${b.pattern}" => b
    }
}

resource "github_branch_protection" "this" {
    for_each = local.branch_protections

    repository_id = each.value.repository_id
    pattern       = each.value.pattern
    required_linear_history = each.value.settings.required_linear_history
}

output "branch_protections" {
  value = local.branch_protections
}
