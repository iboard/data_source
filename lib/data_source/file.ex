defmodule Datasource.File do
  @moduledoc """
  Can be used in `Datasource` as the function-argument. It streams a given file.
  """

  @doc """
  Get next line from the file(stream)

  ### Examples:

  Read through datasource reads the file as stream and should give the
  same result as reading the file directly.

      iex> expected = File.read!("README.md")
      ...> num_lines = (String.split(expected, "\\n") |> Enum.count) - 1 
      ...> 
      ...> # Start the datasource for file "README"
      ...> {:ok, file_source} = Datasource.start_link("README.md", &Datasource.File.next/1)
      ...>
      ...> # Call `next()` number of lines times
      ...> subject = 
      ...>   Enum.map((1..num_lines), fn(_) -> Datasource.next(file_source) end)
      ...>   |> Enum.join
      ...>
      ...> assert subject == expected
      true

      
  You can use `Enum.flat_map_reduce` to read from the datasource until it returns
  `:no_data`.

      iex> {:ok, file_source} = Datasource.start_link("README.md", &Datasource.File.next/1)
      ...> { _, cnt } = Enum.flat_map_reduce((0..1000), 0, fn x, acc ->
      ...>   if Datasource.next(file_source) == :no_data, do: {:halt, acc}, else: {[x], acc + 1}
      ...> end)
      ...> assert cnt <= 1000
      true

  """
  def next(filename) when is_binary(filename), do: next(File.stream!(filename))
  def next(stream) do
    next_line = Stream.take(stream,1) |> Enum.map(&(&1)) |> hd
    {next_line, Stream.drop(stream,1) }
  end

end



