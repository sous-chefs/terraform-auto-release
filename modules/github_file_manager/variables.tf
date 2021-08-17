variable "kube_config" {
  type = object({
    host                   = string
    token                  = string
    cluster_ca_certificate = string
  })
}

variable "namespace" {
  description = "Which namespace to deploy into, must be pre-created"
}

variable "resource_name" {
  description = "The name of the resource to create"
}

variable "cronjob_schedule" {
  description = "When to run, in cron format"
}

variable "app_version" {
  description = "The version of label manager to run"
}

variable "github_token_secret_name" {
  description = "The name of the secret which contains the github_token"
}

variable "source_repo_owner" {
  description = "The name of the source repo with label definitions"
}

variable "source_repo_name" {
  description = "The name of the source repo with label definitions"
  default     = "repo-management"
}

variable "source_repo_path" {
  description = "The path in the repository to find the label definitions"
}

variable "destination_repo_topics" {
  description = "Topics to use to find the repos to match against"
}

variable "destination_repo_owner" {
  description = "The name of the owner for the repos we wish to find"
}

variable "branch_name" {
  description = "The name of the branch to create changes on"
  default     = "automated/standardfiles"
}

variable "pr_title" {
  description = "The title of the pr to raise"
  default     = "Automated PR: Standardising Files"
}

variable "pr_body" {
  description = "The body of the pr to raise"
  default     = ""
}

variable "pr_labels" {
  description = "The labels for the pr"
  type = list(string)
  default     = ["Release: Patch", "Skip: Announcements"]
}
locals {
  pr_labels = join(",", var.pr_labels)
}

variable "changelog_location" {
  description = "The location of the changelog"
  default     = "CHANGELOG.md"
}

variable "changelog_marker" {
  description = "The marker in the changelog as to where to update from"
  default     = "## Unreleased"
}

variable "manage_changelog" {
  description = "Should we manage the changelog?"
  default     = true
}

locals {
  default_body = <<BODY
This PR will standardise the files we have with out agreed spec in ${var.source_repo_owner}/${var.source_repo_name}.
This repo has been identified by topic(s) of ${var.destination_repo_topics}
BODY
  pr_body      = var.pr_body == "" ? local.default_body : var.pr_body
}
