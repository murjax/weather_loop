defmodule WeatherLoop.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias WeatherLoop.Repo

      import Ecto
      import Ecto.Query
      import WeatherLoop.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(WeatherLoop.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(WeatherLoop.Repo, {:shared, self()})
    end

    :ok
  end
end
