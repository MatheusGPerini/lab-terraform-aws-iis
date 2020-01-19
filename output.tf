output "elb_dns" {
  value = "${aws_elb.elb_lab.dns_name}"
}

output "autoscaling_name" {
  value = "${aws_autoscaling_group.asg_lab.name}"
}

output "launch_configuration_name" {
  value = "${aws_launch_configuration.lc_lab.name}"
}

