resource "aws_iam_role" "ira_workshop_role" {
  name = "ira_workshop_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:SetSourceIdentity","sts:TagSession"]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rolesanywhere.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ira_workshop_policy" {
  name = "ira_workshop_policy"
  role = aws_iam_role.ira_workshop_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "ira_workshop_iam_role" {
    value = aws_iam_role.ira_workshop_role.arn
}