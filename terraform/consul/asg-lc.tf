data "aws_ami" "ami" {
    most_recent = true

    filter {
        name = "owner-id"
        values = ["347601599163"]
    }

    filter {
        name = "name"
        values = ["ubuntu-docker-base*"]
    }

}

# Define LC Userdata
data "template_file" "user_data" {
    template = "${file("${path.module}/templates/userdata.sh")}"
}

# Create Launch Configuration
resource "aws_launch_configuration" "main" {
  name_prefix = "${var.tenant}-${var.type}-${var.environment}-"
  image_id = "${data.aws_ami.ami.image_id}"
  instance_type = "t2.nano"
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name = "${var.ssh_key}"
  enable_monitoring = false

  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# ASG
resource "aws_autoscaling_group" "main" {
  name = "${var.tenant}-${var.type}-${var.environment}-asg"
  launch_configuration = "${aws_launch_configuration.main.name}"
  vpc_zone_identifier = ["subnet-ee549ab7", "subnet-ee549ab7", "subnet-ee549ab7"]
  max_size = "3"
  min_size = "3"
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = "3"
  termination_policies = ["OldestInstance"]
  load_balancers = ["${aws_elb.elb.name}"]

  lifecycle {
    ignore_changes = [
      "max_size",
      "min_size",
      "desired_capacity"
      ]
  }

  tag {
    key = "Name"
    value = "${var.tenant}-${var.type}-${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = "DJ Enriquez"
    propagate_at_launch = true
  }
  tag {
    key = "Type"
    value = "${var.type}"
    propagate_at_launch = true
  }
tag {
    key = "Tenant"
    value = "${var.tenant}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }
}