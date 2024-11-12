data "aws_network_interface" "fargate_task_eni" {
  count = 1
  filter {
    name   = "subnet-id"
    values = [module.vpc.subnet_id]
  }
}


output "fargate_public_ip" {
  value       = data.aws_network_interface.fargate_task_eni[0].association[0].public_ip
  description = "Public IP address of the Fargate task."
}
