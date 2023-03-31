data "aws_iam_policy" "cloudwatch_agent_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create IAM Policy
resource "aws_iam_policy" "webapp_s3_policy" {
  name        = "webapp-s3-policy"
  path        = "/"
  description = "Policy for web application to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjects"
        ]
        Resource = ["arn:aws:s3:::${aws_s3_bucket.webapp_bucket.id}", "arn:aws:s3:::${aws_s3_bucket.webapp_bucket.id}/*"]
      }
    ]
  })
}

# Create IAM Role
resource "aws_iam_role" "ec2_csye6225_role" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my-policy-attach" {
  depends_on = [
    aws_iam_policy.webapp_s3_policy
  ]
  for_each = {
    cloudwatch = data.aws_iam_policy.cloudwatch_agent_policy.arn,
    s3         = aws_iam_policy.webapp_s3_policy.arn
  }
  role       = aws_iam_role.ec2_csye6225_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_csye6225_role.name
}