##############################
# Define policies
##############################
data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = "AssumeRole"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "provisioning" {
  statement {
    sid = "AllowS3"
    actions = [
        "s3:Get*",
        "s3:List*"
    ]
    resources = [
        "arn:aws:s3:::immutable-infrastructure",
        "arn:aws:s3:::immutable-infrastructure/*"
    ]
  }
  statement {
    sid = "AllowTagging"
    actions = [
        "ec2:CreateTags",
        "ec2:DescribeTags"
    ]
    resources = [
        "*"
    ]
  }
}

data "aws_iam_policy_document" "consul_agent" {
  statement {
    sid = "AllowConsulAutodiscovery"
    actions = [
        "ec2:DescribeHosts",
        "ec2:DescribeInstances"
    ]
    resources = [
        "*"
    ]
  }
}

##############################
# IAM role
##############################
resource "aws_iam_role" "main" {
  name = "${var.tenant}-${var.type}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

##############################
# Assign inline policies to IAM role
##############################
resource "aws_iam_role_policy" "provisioning" {
  name = "provisioning"
  role = "${aws_iam_role.main.id}"
  policy = "${data.aws_iam_policy_document.provisioning.json}"
}
resource "aws_iam_role_policy" "consul_agent" {
  name = "consul_agent"
  role = "${aws_iam_role.main.id}"
  policy = "${data.aws_iam_policy_document.consul_agent.json}"
}

##############################
# Define IAM Instance Profile
##############################
resource "aws_iam_instance_profile" "main" {
  name = "${aws_iam_role.main.name}"
  role = "${aws_iam_role.main.name}"
}
