defmodule Datasource.DataStage do
  @moduledoc """
  A DataStage takes a `Datasource` as argument and takes values from this
  source on demand.
  """

  use GenStage

  def start_link(source) do
    GenStage.start_link(__MODULE__, source)
  end

  def init(source) do
    {:producer, source}
  end


  def handle_demand(demand, source) do
    events = 
      (1..demand) |> Enum.map( fn(_i) -> Datasource.next(source) end)
    {:noreply, events, source}
  end
end

