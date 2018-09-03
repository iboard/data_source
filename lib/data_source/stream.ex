defmodule Datasource.Stream do
  @moduledoc """
  Can be used in `Datasource` as the function-argument
  """

  @doc """
  Returns and drops the next entry from the stream.

  If `Stream.take(1)` fails then Enum.map |> hd will raise an exception
  which will be catched by `Datastream.next/1` and convert to :no_data

  The reason for this kind of error handling is that eg. hw-sensors
  may crash when used as data-source, thus the module `Datasource` must
  handle errors anyway.

  Also, this means, any Datasource is an infinite stream and you
  can ask for `.next` infinitely.

  ### Example:
      
      iex> stream = (1..3) |> Stream.map(&(&1))
      ...> {:ok, stream_source} = Datasource.start_link(stream, &Datasource.Stream.next/1)
      ...> (1..5) |> Enum.map( fn(_i) -> Datasource.next(stream_source) end)
      [1, 2, 3, :no_data, :no_data]

  """
  def next(stream) do
    { 
      Stream.take(stream,1) |> Enum.map(&(&1)) |> hd, 
      Stream.drop(stream,1)
    } 
  end

end


