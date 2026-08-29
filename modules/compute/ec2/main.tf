resource "aws_security_group" "ec2_security_group" {
  name        = "${var.standard_name}-ec2-sg"
  description = "Security group for ${var.standard_name} EC2 instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ingress_cidr_blocks

    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  tags = var.tags
}

resource "aws_instance" "application_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile = var.iam_instance_profile
  tags = merge(var.tags, {
    Name = "${var.standard_name}-ec2"
  })
}