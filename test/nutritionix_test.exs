defmodule NutritionixTest do
  use ExUnit.Case

  setup do
    System.put_env("NUTRITIONIX_APP_KEY", "apikey")
    System.put_env("NUTRITIONIX_APP_ID", "apiid")
  end

  doctest Nutritionix

  describe "client/1" do
    test "returns errors nicely isntead of raising exceptions" do
      System.delete_env("NUTRITIONIX_APP_KEY")
      assert {:error, _message} = Nutritionix.client("userid")
    end
  end
end
