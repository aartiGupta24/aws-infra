data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ebs_key" {
  description             = "KMS Key for EBS Volume"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.ebs_key_policy.json
}

resource "aws_kms_alias" "ebs_key_alias" {
  name          = "alias/ebs_key"
  target_key_id = aws_kms_key.ebs_key.key_id
}

resource "aws_kms_key" "rds_key" {
  description             = "KMS Key for RDS Instance"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.rds_key_policy.json
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/rds_key"
  target_key_id = aws_kms_key.rds_key.key_id
}