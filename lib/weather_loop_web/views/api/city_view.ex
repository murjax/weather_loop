defmodule WeatherLoopWeb.Api.CityView do
  use WeatherLoopWeb, :view

  def render("index.json", %{cities: cities}) do
    %{cities: cities}
  end

  def render("show.json", %{response: response}), do: response
end
