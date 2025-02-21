# Get modernisation account id from ssm parameter
data "aws_ssm_parameter" "modernisation_platform_account_id" {
  name = "modernisation_platform_account_id"
}

# Get secret by arn for environment management
data "aws_secretsmanager_secret" "environment_management" {
  provider = aws.modernisation-platform
  name     = "environment_management"
}

# Get latest secret value with ID from above. This secret stores account IDs for the Modernisation Platform sub-accounts
data "aws_secretsmanager_secret_version" "environment_management" {
  provider  = aws.modernisation-platform
  secret_id = data.aws_secretsmanager_secret.environment_management.id
}

#tfsec:ignore:AWS095
resource "aws_secretsmanager_secret" "airflow_iam_access_key_id" {
  # checkov:skip=CKV_AWS_149:No requirement currently to encrypt this secret with customer-managed KMS key
  # checkov:skip=CKV2_AWS_57:Auto rotation not possible
  name       = "/${local.application_name}/${local.environment}/airflow/iam-access-key-id"
  kms_key_id = "alias/aws/secretsmanager"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "airflow_iam_access_key_id" {
  secret_id     = aws_secretsmanager_secret.airflow_iam_access_key_id.id
  secret_string = module.airflow_iam_user.iam_access_key_id
}

#tfsec:ignore:AWS095
resource "aws_secretsmanager_secret" "airflow_iam_access_key_ses_smtp_password" {
  # checkov:skip=CKV_AWS_149:No requirement currently to encrypt this secret with customer-managed KMS key
  # checkov:skip=CKV2_AWS_57:Auto rotation not possible
  name       = "/${local.application_name}/${local.environment}/airflow/iam-access-key-ses-smtp-password"
  kms_key_id = "alias/aws/secretsmanager"

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "airflow_iam_access_key_ses_smtp_password" {
  secret_id     = aws_secretsmanager_secret.airflow_iam_access_key_ses_smtp_password.id
  secret_string = module.airflow_iam_user.iam_access_key_ses_smtp_password_v4
}
