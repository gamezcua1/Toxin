defmodule Toxin do
  use Application

  def start() do
    :mnesia.start()
    :mnesia.restore('data.BUPTMP', [])
    create_db()
    backing_up()

    children = [
      {Task.Supervisor, name: Server.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Toxin.Server.start(4040) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Toxin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create_db() do
    :mnesia.create_schema([node()])
    :mnesia.start()
    :mnesia.create_table(Book, Models.Book.schema())
  end

  def drop_db() do
    :mnesia.delete_table(Book)
  end

  def backing_up() do
    :timer.apply_interval(10000, :mnesia, :backup, ['data.BUPTMP'])
  end
end
