defmodule DataSource.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # {DataSource.Worker, arg},
    ]

    opts = [strategy: :one_for_one, name: DataSource.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
