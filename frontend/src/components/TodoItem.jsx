function TodoItem({ todo, onDelete, onToggle }) {

  return (
    <div className="todo-item">

      <div>
        <h3>{todo.title}</h3>
        <p>{todo.description}</p>
      </div>

      <div className="todo-actions">

        <button
          onClick={() => onToggle(todo)}
        >
          {todo.completed ? 'Completed' : 'Mark Complete'}
        </button>

        <button
          onClick={() => onDelete(todo.todo_id)}
        >
          Delete
        </button>

      </div>

    </div>
  )
}

export default TodoItem