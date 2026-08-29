# Building a consistent resource name using the company, team, project and environment inputs
locals {
  name_prefix = lower(
    replace(
      "${var.company}-${var.team}-${var.project}-${var.environment}",
      "_",
      "-"
    )
  )

  common_tags = {
    Team        = var.team
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "project-cob"
    Platform    = "cob"
  }
}