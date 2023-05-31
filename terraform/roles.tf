# Create instance profile
resource "aws_iam_instance_profile" "server_profile" {
    name = "PROJECTXLOGICTIERSERVERINSTANCEPROFILE"
    role = aws_iam_role.server_role.name

    inline_policy {
        name = "project_x_inline_policy_ec2_read_access"

        policy = jsonencode(
            {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
        )

    tags = {
        Environment = "prod"
    }
}
}

# Define policy document
data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

# Create Role
resource "aws_iam_role" "server_role" {
    name = "PROJECTXROLE"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.assume_role

    tags = {
        Environment = "prod"
    }
}