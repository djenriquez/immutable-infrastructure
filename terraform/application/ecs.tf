resource "aws_ecs_cluster" "ecs" {
  name = "${var.tenant}-${var.environment}"
}