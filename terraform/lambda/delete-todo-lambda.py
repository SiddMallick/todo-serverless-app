import json
import boto3

from boto3.dynamodb.conditions import Key

ddb = boto3.resource('dynamodb')
todo_table = ddb.Table('todo-table-dev')

def lambda_handler(event, context):

    user_id = 'USER#demo-user'

    todo_id = event['pathParameters']['todo_id']

    try:
        response = todo_table.delete_item(
            Key = {
                'user_id': user_id,
                'todo_id': todo_id
            },
            ConditionExpression = 'attribute_exists(todo_id)'
        )

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body' : json.dumps({
                'message': 'TODO Deleted successfully',
                'todo_id': todo_id
            })
        }

    except Exception as e:

        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body' : json.dumps({
                'message': 'TODO not found',
                'todo_id': todo_id
            })
        }