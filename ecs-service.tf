resource "aws_alb" "ecs-load-balancer" {
  name            = "tigerconnect-ecs-load-balancer"
  security_groups = ["${aws_security_group.db_access_sg.id}"]
  subnets         = module.vpc_community.public_subnets
}

resource "aws_alb_target_group" "ecs-target_group" {
  name     = "tigerconnect-ecs-targetgroup"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = module.vpc_community.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target_group.arn
    type             = "forward"
  }
}

resource "aws_efs_file_system" "wordpress-data" {
  creation_token   = "es-persistent-data"
  performance_mode = "generalPurpose"

  tags = {
    Name = "wordpress-data"
  }
}

resource "aws_efs_mount_target" "wordpress" {
  count          = "2"
  file_system_id = aws_efs_file_system.wordpress-data.id
  subnet_id      = element(module.vpc_community.public_subnets, count.index)
}

resource "aws_ecs_service" "tigerconnect-ecs-service" {
  name            = "tigerconnect-ecs-service"
  iam_role        = aws_iam_role.ecs-service-role.arn
  cluster         = aws_ecs_cluster.tigerconnect-ecs-cluster.id
  task_definition = aws_ecs_task_definition.demo-sample-definition.arn
  desired_count   = 1
  depends_on      = ["aws_alb_listener.alb-listener"]

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target_group.arn
    container_port   = 80
    container_name   = "wordpress-app"
  }

}
