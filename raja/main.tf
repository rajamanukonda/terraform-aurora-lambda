terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"
  engine_version                 = 13.3
  db_subnet_group_name    = "raja"
  database_name           = "postgres"
  master_username         = "postgres"
  master_password         = "raja1234"
  backup_retention_period = 7
  preferred_backup_window = "09:00-09:30"
  skip_final_snapshot     = true
}
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value = "${aws_rds_cluster.default.endpoint}"
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = aws_rds_cluster.default.master_password
  sensitive   = true
}

locals {
  cnt = length(aws_rds_cluster_instance.cluster_instances)-1
}

data "aws_lambda_invocation" "example" {
  function_name = "raja"

  input = <<JSON
{
  "endpoint": "${aws_rds_cluster_instance.cluster_instances[local.cnt].endpoint}",
  "password": "${aws_rds_cluster.default.master_password}",
  "APPLY_DATE": "${formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())}"
}
JSON

}


output "result" {
  value = jsondecode(data.aws_lambda_invocation.example.result)
}
