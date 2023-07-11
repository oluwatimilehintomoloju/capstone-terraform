resource "aws_security_group" "node_group_sg" {
    name = var.node_group_name  

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "-1"
    }
    
    egress {
        description = "Allow traffic to the internet"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_security_group_rule" "sg_rule" {
    type = "ingress"
    from_port = 1025
    to_port = 65535
    protocol = "TCP"
    self = true
    // Will add source_security_group_id when EKS security group has been created
    security_group_id = aws_security_group.node_group_sg.id
  
}