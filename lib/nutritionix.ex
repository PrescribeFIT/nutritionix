defmodule Nutritionix do
  @moduledoc """
  Nutritionix is a service for retrieving Nutritional information about generic
  or branded foods.

  This is the basic module for most Nutritionix operations.
  """

  @doc """
  Autocomplete an ingredient.
  """
  def ingredient_search(client, term) do
    Tesla.get(client, "/v2/search/instant", query: [query: term])
  end

  def client(args) do
    Nutritionix.Client.new(args)
  end

  def client!(args) do
    Nutritionix.Client.new!(args)
  end
end
