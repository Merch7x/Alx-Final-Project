# data "aws_ecs_task" "example" {
#   cluster  = aws_ecs_cluster.my_cluster.id
#   task_arn = aws_ecs_service.my_service.task_definition
#   # Adjust the above as per your ECS service and task
# }

# output "container_public_ip" {
#   description = "The public IP address of the ECS container"
#   value       = data.aws_ecs_task.example.network_interfaces[0].association.public_ip
# }
