defmodule Datasource.Time do
  @moduledoc """
  Can be used in `Datasource` as the function-argument. It returns the current
  OS time in milliseconds.
  """

  @doc """
  Return current time in milliseconds

  ### Examples:
      
      iex> {:ok, time_source} = Datasource.start_link(:milliseconds, &Datasource.Time.next/1)
      iex> now = System.os_time(:milliseconds)
      iex> subject = Datasource.next(time_source)
      iex> assert_in_delta(now, subject, 1)
      true
  
  """
  def next(precision) do
    { 
      System.os_time(precision),
      precision
    } 
  end

end


