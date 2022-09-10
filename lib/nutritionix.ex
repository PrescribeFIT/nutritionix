defmodule Nutritionix do
  @moduledoc """
  Nutritionix is a service for retrieving Nutritional information about generic
  or branded foods.

  This is the basic module for most Nutritionix operations.
  """

  @spec client(%{app_id: String.t(), app_key: String.t(), user_id: String.t()}) ::
          {:error, any} | {:ok, Tesla.Client.t()}

  def client(args) do
    Nutritionix.Client.new(args)
  end

  @spec client!(%{app_id: String.t(), app_key: String.t(), user_id: String.t()}) ::
          Tesla.Client.t()
  def client!(args) do
    Nutritionix.Client.new!(args)
  end

  ## API endpoints

  @doc """
  Autocomplete an ingredient.

  Great for search boxes for adding new ingredients.
  """
  @spec ingredient_autocomplete(Tesla.Client.t(), String.t()) ::
          {:error, any} | {:ok, Tesla.Env.t()}
  def ingredient_autocomplete(client, term) do
    # note: pass in detailed=true to include nutrient details here
    Tesla.get(client, "/v2/search/instant", query: [query: term])
  end

  @spec parse_description(Tesla.Client.t(), String.t()) :: {:error, any} | {:ok, Tesla.Env.t()}
  def parse_description(client, description) do
    Tesla.post(client, "/v2/natural/nutrients", body: [query: description])
  end
end
