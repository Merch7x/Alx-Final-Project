terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "Merch7x"

    workspaces {
      name = "Dev"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

module "vpc" {
  source       = "../../modules/vpc"
  sec_grp_name = var.sec_grp_name
}


# resource "aws_efs_file_system" "my_efs" {
#   creation_token   = "my-efs-file-system"
#   performance_mode = "generalPurpose" # Can also be "maxIO"
#   tags = {
#     Name = "MyEFS"
#   }
# }

# # Create Mount Targets in Multiple Availability Zones
# resource "aws_efs_mount_target" "mount_target_a" {
#   file_system_id  = aws_efs_file_system.my_efs.id
#   subnet_id       = "subnet-abc123" # Replace with your subnet ID
#   security_groups = ["sg-abc123"]   # Replace with your security group ID
# }

# resource "aws_efs_mount_target" "mount_target_b" {
#   file_system_id  = aws_efs_file_system.my_efs.id
#   subnet_id       = "subnet-def456" # Replace with your subnet ID
#   security_groups = ["sg-abc123"]   # Replace with your security group ID
# }

# # Create a Security Group for Fargate to access EFS
# resource "aws_security_group" "fargate_efs_sg" {
#   name        = "fargate-efs-security-group"
#   description = "Security group for Fargate to access EFS"
#   vpc_id      = "vpc-abc123" # Replace with your VPC ID

#   ingress {
#     from_port       = 2049
#     to_port         = 2049
#     protocol        = "tcp"
#     security_groups = ["sg-abc123"] # Allow access from Fargate tasks security group
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1" # Allow all outbound traffic
#   }
# }

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}



resource "aws_ecs_cluster" "Blog_cluster" {
  name = "Blog-ecs-cluster"
}

# Create an ECS Task Definition with the EFS Volume
resource "aws_ecs_task_definition" "Blog_task" {
  family                   = "my-Blog_task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_instance_role.arn
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "Blog-container"
      image     = "merch7x/flask-blog:pr-8"
      memory    = 512
      cpu       = 256
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
      }]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "Blog-ecs-service"
  cluster         = aws_ecs_cluster.Blog_cluster.id
  task_definition = aws_ecs_task_definition.Blog_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [module.vpc.subnet_id]
    security_groups  = [module.vpc.security_group_id]
    assign_public_ip = true
  }
}
