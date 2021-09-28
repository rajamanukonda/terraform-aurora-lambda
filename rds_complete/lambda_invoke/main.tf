data "aws_lambda_invocation" "example" {
  function_name = "raja"

  input = <<JSON
{
  "endpoint": "${var.db_instance_endpoint}",
  "password": "${var.db_master_password}",
  "APPLY_DATE": "${formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())}",
  depends_on : "${resource.aws_rds_cluster_instance.db_cluster_instances}"
}
JSON

}


output "result" {
  value = jsondecode(data.aws_lambda_invocation.example.result)
}
