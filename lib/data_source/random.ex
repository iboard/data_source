defmodule Datasource.Random do
  @moduledoc """
  Can be used in `Datasource` as the function-argument. It generates
  random float numbers between 0.0 and 1.0
  """

  @precision 1_000_000_000_000_000_000

  @doc """
  Get a random number between 0.0 and 1.0

  ### Examples:
      
      iex> {:ok, random_source} = Datasource.start_link(nil, &Datasource.Random.next/1)
      ...> [a,b,c,d,e] = (1..5) |> Enum.map( fn(_i) -> Datasource.next(random_source) end)
      ...> assert a != b
      ...> assert b != c
      ...> assert c != d
      ...> assert d != e
      true
      
      
  """
  def next(_) do
    { 
      :rand.uniform(@precision)/@precision,
      nil
    } 
  end

end


