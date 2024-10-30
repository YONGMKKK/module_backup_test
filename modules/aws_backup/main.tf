resource "aws_backup_plan" "backup_plan" {
  name = "aws-services-backup-plan"

  rule {
    rule_name           = "aws-services-backup-rule"
    target_vault_name   = aws_backup_vault.backup_vault.name
    schedule            = var.backup_frequency
    start_window        = 60          # optional: time in minutes, before beginning a backup
    completion_window   = 180         # optional: time in minutes, attempts a backup before canceling the job
    lifecycle {
      delete_after = var.backup_retention
    }
    copy_action {
      destination_vault_arn = aws_backup_vault.backup_vault.arn
    }
  }
}

resource "aws_backup_vault" "backup_vault" {
  name = "aws-services-backup-vault"
  kms_key_arn = var.backup_encryption
}

# Add the vault lock (use an example from the Terraform documentation)
resource "aws_backup_vault_lock_configuration" "backup_vault_lock" {
  backup_vault_name   = aws_backup_vault.backup_vault.name
  changeable_for_days = 3
  max_retention_days  = 1200
  min_retention_days  = 7
}

resource "aws_backup_selection" "backup_selection" {
  name         = "aws-services-backup-selection"
  plan_id      = aws_backup_plan.backup_plan.id # associated with the backup plan
  iam_role_arn = aws_iam_role.backup_role.arn

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ToBackup"
    value = "true"
  }

  selection_tag {
    type  = "STRINGEQUALS"  # NOTE: not found the <= option
    key   = "Owner"
    value = var.owner_email
  }
}

resource "aws_iam_role" "backup_role" {
  name        = "aws-backup-role"
  description = "Role for AWS Backup"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}