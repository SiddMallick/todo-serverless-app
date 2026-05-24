import { useEffect, useState } from 'react'

import './App.css'

import TodoForm from './components/TodoForm'
import TodoList from './components/TodoList'

import {
  getTodos,
  createTodo,
  deleteTodo,
  updateTodo
} from './api'

function App() {

  const [todos, setTodos] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    loadTodos()
  }, [])

  async function loadTodos() {

    try {

      setLoading(true)

      const data = await getTodos()

      setTodos(data)

    } catch (err) {

      setError(err.message)

    } finally {

      setLoading(false)
    }
  }

  async function handleAddTodo(todo) {

    try {

      const createdTodo = await createTodo(todo)

      setTodos((prev) => [createdTodo, ...prev])

    } catch (err) {

      setError(err.message)
    }
  }

  async function handleDelete(todoId) {

    try {

      await deleteTodo(todoId)

      setTodos((prev) =>
        prev.filter((todo) => todo.todo_id !== todoId)
      )

    } catch (err) {

      setError(err.message)
    }
  }

  async function handleToggle(todo) {

    try {

      const updatedTodo = {
        completed: !todo.completed
      }

      await updateTodo(todo.todo_id, updatedTodo)

      setTodos((prev) =>
        prev.map((t) =>
          t.todo_id === todo.todo_id
            ? {
                ...t,
                completed: !t.completed
              }
            : t
        )
      )

    } catch (err) {

      setError(err.message)
    }
  }

  return (
    <div className="container">

      <h1>Serverless TODO App</h1>

      <TodoForm onAddTodo={handleAddTodo} />

      {
        loading
          ? <p>Loading...</p>
          : (
              <TodoList
                todos={todos}
                onDelete={handleDelete}
                onToggle={handleToggle}
              />
            )
      }

      {
        error && (
          <p className="error">{error}</p>
        )
      }

    </div>
  )
}

export default App