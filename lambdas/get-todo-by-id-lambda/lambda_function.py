import json
import boto3

ddb = boto3.resource('dynamodb')
todo_table = ddb.Table('todo-dev')

def lambda_handler(event, context):

    user_id = 'USER#demo-user'
    todo_id = event['pathParameters']['todo_id']

    try:

        response = todo_table.get_item(
            Key={
                'user_id': user_id,
                'todo_id': todo_id
            }
        )

        item = response.get('Item')

        if not item:
            return {
                'statusCode': 404,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'message': 'Not found'
                })
            }

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(item)
        }

    except Exception as err:

        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Failed to fetch TODO',
                'error': str(err)
            })
        }