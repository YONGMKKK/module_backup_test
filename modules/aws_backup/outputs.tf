output "backup_plan_id" {
  value       = aws_backup_plan.backup_plan.id
  description = "ID of the backup plan"
}

output "backup_vault_name" {
  value       = aws_backup_vault.backup_vault.name
  description = "Name of the backup vault"
}