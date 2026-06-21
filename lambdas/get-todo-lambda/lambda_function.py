import json
import boto3

ddb = boto3.resource('dynamodb')
todo_table = ddb.Table('todo-dev')

def lambda_handler(event, context):

    items = todo_table.scan()['Items']

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(items)
    }