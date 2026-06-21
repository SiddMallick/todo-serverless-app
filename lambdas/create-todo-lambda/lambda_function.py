import json
import boto3
import uuid
from datetime import datetime

ddb = boto3.resource('dynamodb')
todo_table = ddb.Table('todo-dev')

def lambda_handler(events, context):

    body = json.loads(events['body'])

    todo_id = str(uuid.uuid4())

    item = {
        'user_id' : 'USER#demo-user',
        'todo_id' : todo_id,
        'title': body['title'],
        'description' : body['description'],
        'completed' : False,
        'created_at': datetime.utcnow().isoformat()
    }

    todo_table.put_item(Item = item)

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(item)
    }