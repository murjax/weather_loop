defmodule WeatherLoop.SnapshotConversionsPropertyTest do
  use ExUnit.Case
  use PropCheck
  alias WeatherLoop.SnapshotConversions

  property ".cardinal_direction is string when valid" do
    forall type <- range(0, 360) do
      (SnapshotConversions.cardinal_direction(type) |> Kernel.is_binary) == true
    end
  end

  property ".cardinal_direction is nil when negative" do
    forall type <- neg_integer() do
      SnapshotConversions.cardinal_direction(type) == nil
    end
  end

  property ".cardinal_direction is nil when over 360" do
    forall type <- range(361, 10000) do
      SnapshotConversions.cardinal_direction(type) == nil
    end
  end

  property ".cardinal_direction is nil when float" do
    forall type <- float() do
      SnapshotConversions.cardinal_direction(type) == nil
    end
  end

  property ".convert_epoch is string when valid" do
    forall epoch <- range(100000000, 200000000) do
      SnapshotConversions.convert_epoch(epoch) |> Kernel.is_binary == true
    end
  end

  property ".convert_epoch is nil when negative" do
    forall epoch <- neg_integer() do
      SnapshotConversions.convert_epoch(epoch) == nil
    end
  end

  property ".convert_epoch is nil when float" do
    forall epoch <- float() do
      SnapshotConversions.convert_epoch(epoch) == nil
    end
  end

  property ".convert_epoch is nil post epoch" do
    forall epoch <- range(year_one_post_epoch(), year_ten_post_epoch()) do
      SnapshotConversions.convert_epoch(epoch) == nil
    end
  end

  def year_one_post_epoch do
    Enum.random(2147483648..2179019647)
  end

  def year_ten_post_epoch do
    Enum.random(2463016447..2494638847)
  end
end
