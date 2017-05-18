# Instance security group
resource "aws_security_group" "instance" {
    name = "${var.tenant}-${var.type}-${var.environment}-sg"
    description = "Allows all internal traffic"
    vpc_id = "${var.vpc_id}"

    ingress {   
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        "Name"="${var.tenant}-${var.type}-${var.environment}-sg"
        "terraformed"="true"
    }
}

# Internal ELB security group
resource "aws_security_group" "elb" {
    name = "${var.tenant}-${var.type}-${var.environment}-elb"
    description = "Allows global access"
    vpc_id = "${var.vpc_id}"

    ingress {   
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}