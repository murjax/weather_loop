defmodule WeatherLoop.DayForecasts.ForecastTimes do
  def calculate(time_zone) do
    {:ok, current_time} = Calendar.DateTime.now(time_zone)
    current_date = Calendar.DateTime.to_date(current_time)
    {:ok, beginning_of_day} = DateTime.new(current_date, ~T[00:00:00.000], time_zone)
    {:ok, end_of_day} = DateTime.new(current_date, ~T[23:59:59.999], time_zone)

    day_one_start = DateTime.add(beginning_of_day, 1, :day)
    day_one_end = DateTime.add(end_of_day, 1, :day)
    day_two_start = DateTime.add(beginning_of_day, 2, :day)
    day_two_end = DateTime.add(end_of_day, 2, :day)
    day_three_start = DateTime.add(beginning_of_day, 3, :day)
    day_three_end = DateTime.add(end_of_day, 3, :day)

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
end
