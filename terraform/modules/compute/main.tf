# 1. Look up the Latest Stable Amazon Linux 2023 AMI Dynamically
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-202*x86_64"]
  }
}

# 2. IAM Role for EC2
resource "aws_iam_role" "ec2_logging_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_logging_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ec2_logging_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_logging_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_logging_role.name
}

# 3. Application Load Balancer
resource "aws_lb" "external_alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path = "/health"
    port = "8080"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.external_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

# 4. EC2 Launch Template (Updated with injected MongoDB URI)
resource "aws_launch_template" "backend_template" {
  name_prefix   = "${var.project_name}-${var.environment}-tpl-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  iam_instance_profile { arn = aws_iam_instance_profile.ec2_profile.arn }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.backend_sg_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    # Login to ECR and pull your backend
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com
    docker pull ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
    # Run container securely using variables
    docker run -d -p 8080:8080 \
      -e MONGODB_URI='${var.mongodb_uri}' \
      --restart unless-stopped \
      ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
  EOF
  )
}

# 5. Auto Scaling Group
resource "aws_autoscaling_group" "backend_asg" {
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.backend_tg.arn]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  launch_template {
    id      = aws_launch_template.backend_template.id
    version = "$Latest"
  }
}