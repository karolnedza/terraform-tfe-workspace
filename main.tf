resource "tfe_workspace" "managed" {
  name         = var.name
  organization = var.organization

  auto_apply            = var.auto_apply
  file_triggers_enabled = var.file_triggers_enabled
  queue_all_runs        = var.queue_all_runs
  ssh_key_id            = var.ssh_key_id
  terraform_version     = var.terraform_version
  trigger_prefixes      = var.trigger_prefixes

  dynamic "vcs_repo" {
    for_each = lookup(var.vcs_repo, "identifier", "dummy") == "dummy" ? [] : [var.vcs_repo]
    content {
      branch             = lookup(var.vcs_repo, "branch", null)
      identifier         = lookup(var.vcs_repo, "identifier", null)
      ingress_submodules = lookup(var.vcs_repo, "ingress_submodules", null)
      oauth_token_id     = lookup(var.vcs_repo, "oauth_token_id", null)
    }
  }

  working_directory = var.working_directory
}


resource "tfe_variable" "environment" {
  for_each = lookup(var.variables, "environment", {})

  category  = "env"
  key       = each.key
  value     = each.value
  sensitive = false

  workspace_id = tfe_workspace.managed.id
}

resource "tfe_variable" "environment_sensitive" {
  for_each = lookup(var.variables, "environment_sensitive", {})

  category  = "env"
  key       = each.key
  value     = each.value
  sensitive = true

  workspace_id = tfe_workspace.managed.id
}

resource "tfe_variable" "terraform" {
  for_each = lookup(var.variables, "terraform", {})

  category  = "terraform"
  key       = each.key
  value     = each.value
  sensitive = false

  workspace_id = tfe_workspace.managed.id
}

resource "tfe_variable" "terraform_sensitive" {
  for_each = lookup(var.variables, "terraform_sensitive", {})

  category  = "terraform"
  key       = each.key
  value     = each.value
  sensitive = true

  workspace_id = tfe_workspace.managed.id
}
