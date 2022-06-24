defmodule NutritionixTest do
  use ExUnit.Case
  doctest Nutritionix

  describe "client/1" do
    test "returns a Tesla client" do
      client = Nutritionix.client("fiddytwo")
      assert %Tesla.Client{} = client
    end
  end
end
