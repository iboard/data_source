# DataSource

Part of the `[PocketData][]` project. A DataSource is a "Producer" (of data)
for the system. It can be a simple counter, or a complex "collector", reading
sensors from embeded systems or collecting data from foreign (web-)services.

## Installation
(Not yet released as a hex package)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `data_source` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:data_source, "~> 0.1.0"}
  ]
end
```

[PocketData]: https://github.com/iboard/pocketdata
