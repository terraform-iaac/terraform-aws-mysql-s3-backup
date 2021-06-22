resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"

  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
  }
  EOF

  tags = {
    env = var.env
    managed_by = "Terraform"
  }
}

