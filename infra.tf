##############
# KEY PAIR
##############

resource "aws_key_pair" "lab_key" {
  key_name   = "cloudKey"
  public_key = ""
}


################
# SECURITY GROUP
################

resource "aws_security_group" "sg_lab" {
  name = "lab-${var.environment}"
  vpc_id = "${var.vpc_id}"
  description = "Allow traffic for app application"

  ingress {
    from_port               = 8080
    to_port                 = 8080
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  ingress {
    from_port               = 3389
    to_port                 = 3389
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_elb_lab" {
  name = "elb-lab-${var.environment}"
  vpc_id = "${var.vpc_id}"
  description = "Allow traffic for app application"

  ingress {
    from_port               = 80
    to_port                 = 80
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }
}

######################
# LAUNCH CONFIGURATION
######################

resource "aws_launch_configuration" "lc_lab" {
  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  name = "lc-lab-${var.environment}-${random_id.server.hex}"
  security_groups = ["${aws_security_group.sg_lab.id}"]
  key_name = "${aws_key_pair.lab_key.key_name}"
  user_data = 
  <<-EOT
        <powershell>
          cd C:\
          [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
          curl https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe -o git.exe -UseBasicParsing
          Start-Process -FilePath C:\git.exe -Args '/silent /install' -Verb RunAs -Wait
          C:\'Program Files'\Git\bin\git.exe clone https://github.com/MatheusGPerini/lab-terraform-aws-iis.git
          mkdir c:\website\lab
          cd C:\website\lab
          Copy-Item -Path "C:\lab-terraform-aws-iis\site\*" -Destination "C:\website\lab\" -Recurse
          Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
          Install-WindowsFeature -name Web-Server -IncludeManagementTools
          New-WebAppPool labsite
          New-WebSite -Name labsite -Port 8080 -ApplicationPool labsite -PhysicalPath "C:\website\lab"
        </powershell>
     EOT

  lifecycle {
    create_before_destroy   = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

}

####################
# AUTO SCALING GROUP
####################


resource "aws_autoscaling_group" "asg_lab" {
  name = "asg-lab-${var.environment}-${random_id.server.hex}"
  launch_configuration = "${aws_launch_configuration.lc_lab.name}"
  availability_zones = ["${var.azs}"]
  vpc_zone_identifier = "${var.subnets}"

  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  health_check_grace_period = 120
  health_check_type         = "ELB"
  load_balancers = ["${aws_elb.elb_lab.name}"]

  force_delete = true

  tags = [
    {
      key                             = "Name"
      value                           = "APP-${var.environment}"
      propagate_at_launch             = true
    },
    {
      key                             = "Terraform"
      value                           = "true"
      propagate_at_launch             = true
    }
  ]
    
}

################
# LOAD BALANCER
################

resource "aws_elb" "elb_lab" {
  name     = "elb-${var.environment}"
  internal = false
  subnets  = "${var.subnets}"

  security_groups = ["${aws_security_group.sg_elb_lab.id}"]

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 120

  listener = [
    {
      instance_port      = "8080"
      instance_protocol  = "TCP"
      lb_port            = "80"
      lb_protocol        = "TCP"
    }
  ]

  health_check = [
    {
      target              = "HTTP:8080/"
      interval            = 70
      healthy_threshold   = 2
      unhealthy_threshold = 10
      timeout             = 59
    },
  ]

  tags             = {
    Name           = "elb-${var.environment}"
    Terraform      = "true"
  }
}


resource "random_id" "server" {
  keepers = {

    uuid = "${uuid()}"

    }
  byte_length = 8
}


