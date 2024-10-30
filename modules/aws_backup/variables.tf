variable "backup_frequency" {
  type        = string
  description = "Backup frequency, options: daily, weekly, monthly or cron expression"
}

variable "backup_retention" {
  type        = number
  description = "Backup retention period in days"
}

variable "backup_encryption" {
  type        = string
  description = "Backup encryption key ARN"
}

variable "owner_email" {
  type        = string
  description = "Owner email address, for AWS services tag filter"  
}