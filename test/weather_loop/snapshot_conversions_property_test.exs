defmodule WeatherLoop.SnapshotConversionsPropertyTest do
  use ExUnit.Case
  use PropCheck
  alias WeatherLoop.SnapshotConversions

  property ".cardinal_direction" do
    forall type <- range(0, 360) do
      (SnapshotConversions.cardinal_direction(type) |> Kernel.is_binary) == true
    end

    forall type <- neg_integer() do
      SnapshotConversions.cardinal_direction(type) == nil
    end

    forall type <- range(361, 10000) do
      SnapshotConversions.cardinal_direction(type) == nil
    end

    forall type <- float() do
      SnapshotConversions.cardinal_direction(type) == nil
    end
  end
end
