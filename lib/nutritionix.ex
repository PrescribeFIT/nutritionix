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
  Search for an ingredient.

  Does a front match which supports autocompleting search fields.

  The body of the response here will contain two keys:
  * "branded" - contains branded foods. Each item contains:
    * "nix_item_id" -- The item ID that can be used to look up further details
    * "brand_name" -- The brand name of the item. (e.g. "Thomas'")
    * "food_name" -- The name of the food (e.g. "Light Multi Grain English Muffin")
    * "brand_name_item_name" -- Brand name and food name concatenated together
    * "photo" -- map with one key, "thumb", the URL to the thumbnail image
    * "serving_qty" -- the default serving quantity (e.g. 1)
    * "serving_unit" -- The default serving unit (e.g. "Muffin")
  * "common" - contains generic food items (think apples, white bread, coffee, etc) Each item:
    * "food_name" -- Name of the food (e.g. "grape"). This is also what you use to look up more details.
    * "serving_qty" -- the default serving quantity (e.g. 10)
    * "serving_unit" -- The default serving unit (e.g. "grapes")
    * "photo" -- map with one key, "thumb", the URL to the thumbnail image
  """
  @spec ingredient_search(Tesla.Client.t(), String.t()) ::
          {:error, any} | {:ok, Tesla.Env.t()}
  def ingredient_search(client, term) do
    # note: pass in detailed=true to include nutrient details here
    Tesla.get(client, "/v2/search/instant", query: [query: term])
  end

  @doc """
  Parse a description of a meal into ingredients you can build a meal out of.
  Also used for getting nutritional details from a common food `food_name`
  attribute.

  Foods matched from the description are in the response body under the "Foods"
  key. Details include:

  * "food_name" -- The name of the food, can be used with
    `ingredient_autocomplete\2` or for display.
  * "nf_calories" -- calorie count
  * "nf_cholesterol" -- cholesterol
  * "nf_total_fat" -- total fat
  * "nf_sodium" -- sodium
  * "nf_total_carbohydrate" == carbs
  * "nf_protein" -- protein
  * "nf_sugars" -- sugar
  * "photo" -- map with two keys, "highres" and "thumb", both String URLs.
  * "serving_unit" -- string serving unit ("tbsp", "cup", etc)
  * "serving qty" -- the quantity in the serving
  * "serving_weight_grams" -- the serving weight in grams
  * "alt_measures" -- a list of maps of different ways to serve the ingredient. Keys are:
    * "meausre" -- String measurement name, e.g. "quart"
    * "qty" -- Numeric quantity, e.g. 1
    * "seq" -- Numeric used for ordering these options, say in a dropdown
    * "serving_weight" -- Numeric weight in grams, e.g. 976
    * "meausre" -- String measurement name, e.g. "quart"

  ## Conversion
  (alt_measures.serving_weight / serving_weight_grams) * nutrient_you_care_about

  Alternatively, divide the nutrient you care about by the serving_weight_grams
  to get the value for one gram. This allows arbitrary serving sizes in grams.

  No further API calls need be made for these conversions.

  ## Examples

      iex> {:ok, response} = Nutritionix.parse_description(client,
      ...>                   "bagel with cream cheese and a glass of milk")

      iex> Enum.map(response.body["foods"].map(&(&1["name"]))
      ["bagels", "cream cheese, "glass of milk"]

  """
  @spec parse_description(Tesla.Client.t(), String.t()) :: {:error, any} | {:ok, Tesla.Env.t()}
  def parse_description(client, description) do
    Tesla.post(client, "/v2/natural/nutrients", %{query: description})
  end

  @spec lookup_common(Tesla.Client.t(), Script.t()) :: {:error, any} | {:ok, Tesla.Env.t()}
  defdelegate lookup_common(client, name), to: __MODULE__, as: :parse_description

  @doc """
  Lookup a branded food by its "nix_item_id" property.

  NOTE: Getting a 404, unsure if this is a production concern yet.
  """
  @spec lookup_nix(Tesla.Client.t(), String.t()) :: {:error, any} | {:ok, Tesla.Env.t()}
  def lookup_nix(client, nix_id) do
    Tesla.get(client, "/v2/search/item", query: [nix_item_id: nix_id])
  end
end
