const API_BASE_URL = 'https://todo-apis.treeoftools.click'

export async function getTodos() {
  const response = await fetch(`${API_BASE_URL}/todos`)

  if (!response.ok) {
    throw new Error('Failed to fetch todos')
  }

  return response.json()
}

export async function createTodo(todo) {
  const response = await fetch(`${API_BASE_URL}/todos`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(todo)
  })

  if (!response.ok) {
    throw new Error('Failed to create todo')
  }

  return response.json()
}

export async function deleteTodo(todoId) {
  const response = await fetch(`${API_BASE_URL}/todos/${todoId}`, {
    method: 'DELETE'
  })

  if (!response.ok) {
    throw new Error('Failed to delete todo')
  }

  return response.json()
}

export async function updateTodo(todoId, updatedTodo) {
  const response = await fetch(`${API_BASE_URL}/todos/${todoId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(updatedTodo)
  })

  if (!response.ok) {
    throw new Error('Failed to update todo')
  }

  return response.json()
}