#Creating a AWS Cluster
resource "aws_ecs_cluster" "goals" {
  name = "node-application"
}

#Setting the capacity provider as FARGATE
resource "aws_ecs_cluster_capacity_providers" "goals" {
  cluster_name = aws_ecs_cluster.goals.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

#Task definition for front end container
resource "aws_ecs_task_definition" "goals-react" {
  family                   = "goals-react"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      "essential": true,
      "image": "ponnagsr/node-goals-frontend:latest",
      "name": "goals-frontend",
      "memoryReservation": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/nodegoals",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}

#Task definition for backend container
resource "aws_ecs_task_definition" "nodegoals" {
  family                   = "nodegoals"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      "environment": var.Mongodb_env,
      "essential": true,
      "image": "ponnagsr/node-goals:latest",
      "name": "node-goals",
      "memoryReservation": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/nodegoals",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}

#Service for backend task definition
resource "aws_ecs_service" "backend-goals" {
  name                 = "backend-goals"
  cluster              = aws_ecs_cluster.goals.id
  task_definition      = aws_ecs_task_definition.nodegoals.arn
  desired_count        = 1
  scheduling_strategy  = "REPLICA"
  
  network_configuration {
    subnets            = var.subnet_ids
    assign_public_ip   = true
    security_groups    = var.security_group
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "node-goals"
    container_port   = 80
  }
}

#Service for front end task definition
resource "aws_ecs_service" "goals-react" {
  name                 = "goals-react"
  cluster              = aws_ecs_cluster.goals.id
  task_definition      = aws_ecs_task_definition.goals-react.arn
  desired_count        = 1
  scheduling_strategy  = "REPLICA"
  
  network_configuration {
    subnets            = var.subnet_ids
    assign_public_ip   = true
    security_groups    = var.security_group1
  }
}