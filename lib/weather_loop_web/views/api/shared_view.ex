defmodule WeatherLoopWeb.Api.SharedView do
  use WeatherLoopWeb, :view

  def render("unauthorized.json", _) do
    %{error: "User is unauthorized"}
  end
end
