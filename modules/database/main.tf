resource "aws_db_subnet_group" "database" {
  name       = "${var.standard_name}-db-subnet-group"
  subnet_ids = var.database_subnet_ids
  tags = var.tags
}

resource "aws_security_group" "database" {
  name        = "${var.standard_name}-db-sg"
  description = "Security group for ${var.standard_name} database"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids

    content {
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.standard_name}-db"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  port              = var.port
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  multi_az = var.multi_az
  manage_master_user_password = true
  tags = var.tags
}