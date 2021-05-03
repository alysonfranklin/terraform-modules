// target
resource "aws_alb_target_group" "ecs-service" {
  name = "${var.APPLICATION_NAME}-${substr(
    md5(
      format(
        "%s%s%s",
        var.APPLICATION_PORT,
        var.DEREGISTRATION_DELAY,
        var.HEALTHCHECK_MATCHER,
      ),
    ),
    0,
    5,
  )}"
  port                          = var.APPLICATION_PORT
  protocol                      = "HTTP"
  vpc_id                        = var.VPC_ID
  deregistration_delay          = var.DEREGISTRATION_DELAY
  load_balancing_algorithm_type = var.LOAD_BALANCING_ALGORITHM_TYPE
  tags                          = var.DEFAULT_TAGS

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = var.HEALTHY_THRESHOLD
    unhealthy_threshold = var.UNHEALTHY_THRESHOLD
    protocol            = "HTTP"
    path                = var.HEALTH_CHECK_PATH
    interval            = var.HEALTH_CHECK_INTERVAL
    matcher             = var.HEALTHCHECK_MATCHER
  }
  stickiness {
    type    = "lb_cookie"
    enabled = var.ENABLE_STICKINESS
  }
}
