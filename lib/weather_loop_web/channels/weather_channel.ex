defmodule WeatherLoopWeb.WeatherChannel do
  use Phoenix.Channel

  def join("city", _params, socket) do
    {:ok, socket}
  end
end
