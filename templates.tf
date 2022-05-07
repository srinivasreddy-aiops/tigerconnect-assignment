resource "template_file" "demo-template" {
  template = file("./wordpress.json")

  vars = {
    db_host     = aws_db_instance.rds.address
    db_name     = aws_db_instance.rds.name
    db_user     = aws_db_instance.rds.username
    db_password = random_string.temporary_password.result
  }
}
