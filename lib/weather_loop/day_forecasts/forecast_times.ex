defmodule WeatherLoop.DayForecasts.ForecastTimes do
  def calculate do
    {:ok, current_time} = Calendar.DateTime.now("America/New_York")
    current_date = Calendar.DateTime.to_date(current_time)
    {:ok, beginning_of_day} = DateTime.new(current_date, ~T[00:00:00.000], "America/New_York")
    {:ok, end_of_day} = DateTime.new(current_date, ~T[23:59:59.999], "America/New_York")

    day_one_start = add_to_day_epoch(beginning_of_day, 86400)
    day_one_end = add_to_day_epoch(end_of_day, 86400)
    day_two_start = add_to_day_epoch(beginning_of_day, 172800)
    day_two_end = add_to_day_epoch(end_of_day, 172800)
    day_three_start = add_to_day_epoch(beginning_of_day, 259200)
    day_three_end = add_to_day_epoch(end_of_day, 259200)

    %{
      day_one: %{
        start_of_day: day_one_start,
        end_of_day: day_one_end
      },
      day_two: %{
        start_of_day: day_two_start,
        end_of_day: day_two_end
      },
      day_three: %{
        start_of_day: day_three_start,
        end_of_day: day_three_end
      }
    }
  end

  defp add_to_day_epoch(datetime, seconds) do
    datetime |> DateTime.add(seconds) |> DateTime.to_unix
  end
end
