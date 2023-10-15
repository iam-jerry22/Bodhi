#### RDS

##### Security Group 

resource "aws_security_group" "rds_mysql_access" {
  name_prefix = "${var.cluster_name}-rds-mysql-access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL access from within VPC"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "db-subnet"
  subnet_ids = module.vpc.database_subnets
}

resource "aws_db_instance" "db" {
  #allocated_storage    = 10
  db_name              = var.rds_db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.large"
  allocated_storage     = 5
  max_allocated_storage = 100
  storage_encrypted     = false
  identifier = var.rds_mysql_db_identifier
  username             = "test"
  password             = "test1234"
  #create_random_password = true
  #random_password_length = 12
  port                   = 3306
  iam_database_authentication_enabled = true
  #parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_mysql_access.id]
  
  #  DB subnet group
  db_subnet_group_name = aws_db_subnet_group.database.name
  skip_final_snapshot  = true
  tags = {
    Owner       = "user"
    Environment = "bodhi"
    ENV         = "PRD"
    GRUPO       = "Forecast1x"
  }
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.db.id
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.db.endpoint
}


output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.db.name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.db.username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = aws_db_instance.db.password
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.db.port
}

