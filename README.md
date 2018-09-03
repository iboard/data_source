# DataSource

Part of the `[PocketData][]` project. A DataSource is a "Producer" (of data)
for the system. It can be a simple counter, or a complex "collector", reading
sensors from embeded systems or collecting data from foreign (web-)services.

## Installation

The package is [available in Hex](https://hex.pm/packages/data_source), the package can be installed
by adding `data_source` to your list of dependencies in `mix.exs`:

      def deps do
        [
          {:data_source, "~> 0.1.0"}
        ]
      end

## Example

      # Rememnber consumed events in state
      defmodule ConsumerSpy do
        use GenStage

        def start_link(), do: GenStage.start_link(ConsumerSpy, [])
        def init(state), do: {:consumer, state}

        def handle_events(events, _from, state) do
          # Simulate load
          Process.sleep(10)
          {:noreply, [], [events | state]}
        end

        def handle_call(:get, _from, state) do
          {:reply, Enum.flat_map(state, & &1), [], state}
        end
      end

      {:ok, datasource} = Datasource.start_link(0, fn state -> {state, state + 1} end)
      {:ok, producer} = Datasource.DataStage.start_link(datasource)
      {:ok, consumer} = ConsumerSpy.start_link()

      GenStage.sync_subscribe(consumer, to: producer, max_demand: 1)
      Process.sleep(100)

      ConsumerSpy.call(consumer, :get)
      # => [0,1,2,3,...10]

Because the consumer delays for 10ms and we have 1 consumer only, 
in 100ms we can expect about 10 events. To process more than 10
events you can increase the number of consumers.
    
## Datasources

Some Datasources are defined in `lin/data_source`. Such as
`Datasource.Counter`, `Datasource.File`, and more.


[PocketData]: https://github.com/iboard/pocketdata
