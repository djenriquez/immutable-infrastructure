# Create Internal ELB DNS Record
data "aws_route53_zone" "hosted_zone" {
  name = "djenriquez.com"
}

resource "aws_route53_record" "elb" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name = "consul.immutable-infrastructure.djenriquez.com"
  type = "A"

  alias {
    name = "${aws_elb.elb.dns_name}"
    zone_id = "${aws_elb.elb.zone_id}"
    evaluate_target_health = false
  }
}

# Create Internal ELB
resource "aws_elb" "elb" {
  name = "${var.tenant}-${var.type}-${var.environment}-elb"
  subnets = ["subnet-ee549ab7", "subnet-ee549ab7", "subnet-ee549ab7"]
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 400
  security_groups = ["${aws_security_group.elb.id}"]
  internal = false

  listener {
    instance_port = 8500
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "TCP:8500"
    interval = 30
  }

  lifecycle {
    create_before_destroy = true
  }
}


