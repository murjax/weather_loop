defmodule WeatherLoop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children = [
      # Start the Ecto repository
      WeatherLoop.Repo,
      # Start the Telemetry supervisor
      WeatherLoopWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WeatherLoop.PubSub},
      # Start the Endpoint (http/https)
      WeatherLoopWeb.Endpoint
      # Start a worker by calling: WeatherLoop.Worker.start_link(arg)
      # {WeatherLoop.Worker, arg}
    ]

    mock_server = {Plug.Cowboy, scheme: :http, plug: WeatherLoop.MockServer, options: [port: 8081]}
    children = case args do
      [env: :test] -> children ++ [mock_server]
      [_] -> children
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherLoop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeatherLoopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
