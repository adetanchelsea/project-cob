data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_s3_access" {
  count = var.create_s3_access_policy ? 1 : 0

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_ecs_roles ? 1 : 0

  name               = "${var.standard_name}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  count = var.create_ecs_roles ? 1 : 0

  role       = aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  count = var.create_ecs_roles ? 1 : 0

  name               = "${var.standard_name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "ecs_task_s3" {
  count = var.create_s3_access_policy ? 1 : 0

  name   = "${var.standard_name}-ecs-task-s3"
  role   = aws_iam_role.ecs_task_role[0].id
  policy = data.aws_iam_policy_document.task_s3_access[0].json
}

resource "aws_iam_role" "ec2_instance_role" {
  count = var.create_ec2_role ? 1 : 0

  name               = "${var.standard_name}-ec2-instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_ec2_role ? 1 : 0

  name = "${var.standard_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role[0].name
}