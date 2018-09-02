defmodule Datasource.Counter do
  @moduledoc """
  Can be used in `Datasource` as the function-argument
  """

  @doc """
  Counting

  ### Examples:

  #### A simple, endless counter

      iex> {:ok, counter_source} = Datasource.start_link(0, &Datasource.Counter.next/1)
      iex> (0..3) |> Enum.each( fn(_i) -> Datasource.next(counter_source) end)
      iex> Datasource.next(counter_source)
      4

  """
  def next(state) do
    { state, state + 1 }
  end

end


