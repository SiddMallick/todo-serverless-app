resource "aws_dynamodb_table" "todo_ddb_table_dev" {
  name = "todo-dev"
  billing_mode = "PROVISIONED"
  read_capacity = 2
  write_capacity = 2
  hash_key = "user_id"
  range_key = "todo_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "todo_id"
    type = "S"
  }

  lifecycle {
    ignore_changes = [ read_capacity, write_capacity ]
    prevent_destroy = false
  }
  
  tags = {
    Name = "todo-dev"
    env = "dev"
    managed = "terraform"
  }

}