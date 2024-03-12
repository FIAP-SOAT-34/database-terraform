terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "tech-challenge-grupo34"
    key    = "tech-challenge-db/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "postgres_db" {
  db_name              = var.projectName
  identifier           = "rds-${var.projectName}"
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "16.1" 
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = var.db_password
  parameter_group_name = "default.postgres16"
  apply_immediately = true
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az             = false
  availability_zone = "us-east-1a"

  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name = "postgres-subnet-group"
  subnet_ids = [data.terraform_remote_state.infra.outputs.subnet1_id, data.terraform_remote_state.infra.outputs.subnet2_id]

  tags = {
    name = "RDS postgres subnet group"
  }
}