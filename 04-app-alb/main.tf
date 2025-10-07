
resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = true # internal for private
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

  #enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = var.common_tags
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

# this will add one listener to posrt number 80 and one  default rule
  default_action {
    type = "fixed-response"

  
  fixed_response {
    content_type = "text/plain"
    message_body = "this is the fixed response from App Alb"
    status_code=200
  }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "joindevops.fun"

  records = [
    {
      name    = "*.app"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}