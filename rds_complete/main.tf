module "rds" {
  source="./rds"
}


module "lambda_invoke" {
  source="./lambda_invoke"
  db_instance_endpoint= "${module.rds.db_instance_endpoint}"
  db_master_password = "${module.rds.db_master_password}"
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value = "${module.rds.db_instance_endpoint}"
}

output "db_master_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = "${module.rds.db_master_password}"
  sensitive   = true
}



output "lambda_result" {
  value = "${module.lambda_invoke.result}"
}
