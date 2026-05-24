import TodoItem from './TodoItem'

function TodoList({ todos, onDelete, onToggle }) {

  if (todos.length === 0) {
    return <p>No todos found</p>
  }

  return (
    <div>
      {
        todos.map((todo) => (
          <TodoItem
            key={todo.todo_id}
            todo={todo}
            onDelete={onDelete}
            onToggle={onToggle}
          />
        ))
      }
    </div>
  )
}

export default TodoList