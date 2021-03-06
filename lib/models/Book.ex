defmodule Models.Book do
  alias :mnesia, as: Mnesia

  def schema, do: [attributes: [:name, :author, :year]]
  
  def get_all do
    Mnesia.dirty_match_object({Book, :_, :_, :_})
    |> Enum.map(fn {_, name, author, year} ->
      %{name: name, author: author, year: year}
    end)
  end

  def get(key) do
    
  end

  def save(book) do
    write = fn -> Mnesia.write({Book, book.name, book.author, book.year}) end
    Mnesia.transaction(write)
  end

  def delete(key) do
    delete = fn -> Mnesia.delete({Book, key}) end
    Mnesia.transaction(delete)
  end

end
