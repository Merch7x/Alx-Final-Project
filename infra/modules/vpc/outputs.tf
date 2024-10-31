output "vpc_id" {
  description = "The vpc id"
  value       = aws_vpc.Blog_vpc.id
}

output "security_group_id" {
  description = "The default security grp id"
  value       = aws_default_security_group.Blog_sec_group.id
}

output "subnet_id" {
  description = "The id of the subnet to be used"
  value       = aws_subnet.Blog_az.id

}
