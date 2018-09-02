defmodule DatasourceDatastageTest do
  use ExUnit.Case
  doctest Datasource.DataStage

  defmodule ConsumerSpy do
    use GenStage

    def start_link() do
      GenStage.start_link(ConsumerSpy, [])
    end

    def init(state), do: {:consumer, state}

    def handle_events(events, _from, state) do
      Process.sleep(10)
      {:noreply, [], [events | state]}
    end

    def handle_call(:get, _from, state) do
      {:reply, Enum.flat_map(state, & &1), [], state}
    end
  end

  setup _ do
    {:ok, data_source} = Datasource.start_link(0, fn state -> {state, state + 1} end)
    {:ok, producer} = Datasource.DataStage.start_link(data_source)
    {:ok, consumer} = ConsumerSpy.start_link()
    {:ok, %{producer: producer, consumer: consumer, consumers: consumers(100)}}
  end

  test "consume >= 9 events with one consumer in 100ms", %{producer: producer, consumer: consumer} do
    GenStage.sync_subscribe(consumer, to: producer, max_demand: 1)
    Process.sleep(100)

    assert count_consumed_events([consumer]) >= 9
  end

  test "consume >= 1000 events with 100 consumers in 100ms", %{
    producer: producer,
    consumers: consumers
  } do
    subscribe_consumers(consumers, producer)
    Process.sleep(100)

    assert count_consumed_events(consumers) >= 1000
  end

  defp consumers(n) do
    Enum.map(1..n, fn _ ->
      {:ok, pid} = ConsumerSpy.start_link()
      pid
    end)
  end

  defp subscribe_consumers(consumers, producer) do
    Enum.each(consumers, fn pid ->
      GenStage.sync_subscribe(pid, to: producer, max_demand: 1)
    end)
  end

  defp count_consumed_events(consumers) do
    Enum.reduce(consumers, 0, fn pid, acc ->
      acc + (GenStage.call(pid, :get) |> Enum.count())
    end)
  end
end
