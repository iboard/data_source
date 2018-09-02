defmodule Datasource do
  @moduledoc """
  A `Datasource` is started as a process and implements a
  function `next` which returns the next value of the 
  data source. E.g. for sensors the `next` function reads the
  current value of the sensor and returns that. For file
  sources, it may read the next line and so on.

  If no data available or the datasource crashed the
  `next` function will return `:no_data`
  """

  use Agent

  @doc """
  Instantiate a new Datasource with a `initial_value` and a given function `fun`
  which will be called at `next`. The given function must return a tuple of kind
  `{ requested_value, new_data_source }`. `new_data_source` will be the input
  of the next call to `Datasource.next/1`

  Find examples at `Datasource.next/0`
  """
  def start_link(initial_value \\ nil, fun) do
    Agent.start_link( fn -> { initial_value, fun } end )
  end


  @doc """
  Get the next value of the data source.

  ### Examples:

  #### A simple, endless counter

      iex> {:ok, counter_source} = Datasource.start_link(1, fn(current) -> { current, current + 1 } end)
      iex> (1..3) |> Enum.each( fn(_i) -> Datasource.next(counter_source) end)
      iex> Datasource.next(counter_source)
      4

  #### A Stream of data (which may have an end)
  
      iex> {:ok, stream_source} = Datasource.start_link(Stream.map((0..2), &(&1)), 
      iex>                           fn(stream) -> { Stream.take(stream,1)
      iex>                                           |> Enum.map(&(&1)) 
      iex>                                           |> hd, Stream.drop(stream,1)} 
      iex>                           end
      iex>                         )
      iex> [
      iex>   Datasource.next(stream_source),
      iex>   Datasource.next(stream_source),
      iex>   Datasource.next(stream_source),
      iex>   Datasource.next(stream_source),
      iex>   Datasource.next(stream_source) 
      iex> ]
      [0,1,2,:no_data,:no_data]

  """
  def next(pid) do
    Agent.get_and_update( pid, fn({source,fun}) -> 
      try do
        {next_value, new_source} = fun.(source) 
        {next_value, { new_source, fun }}
      rescue 
        _error -> 
          {:no_data, { source, fun }}
      end
    end)
  end
end
