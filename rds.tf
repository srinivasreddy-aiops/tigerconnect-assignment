
resource "random_string" "temporary_password" {
  length      = 16
  special     = false
  min_numeric = 1
}

/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = module.vpc_community.public_subnets
  tags = {
    Name      = "RDS-subnet-group"
    Terraform = "true"
  }
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = module.vpc_community.vpc_id
  name        = "db-access-sg"
  description = "Allow access to RDS"

  tags = {
    Name      = "db-access-sg"
    Terraform = "true"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security Group for RDS"
  vpc_id      = module.vpc_community.vpc_id
  tags = {
    Name      = "rds-sg"
    Terraform = "true"
  }

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  //allow traffic for TCP port 3306
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.db_access_sg.id}"]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "tigerconnect-database"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.17"
  instance_class         = "db.t3.micro"
  name                   = "tigerconnect-DB"
  username               = "admin"
  password               = random_string.temporary_password.result
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true
  tags = {
    Name      = "tigerconnect-DB"
    Terraform = "true"
  }
}
