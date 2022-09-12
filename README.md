# Nutritionix

A library for querying the [Nutritonix](https://www.nutritionix.com) food database.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nutritionix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nutritionix, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

## Usage

### Creating a client

To create a Nutritionix API client, you need three things:

* From the [Nutritionix Developer site](https://developer.nutitionix.com)
  * The Application ID
  * A generated key
* The User ID you're searching for. In development, this should be `1`. For production, this should be a value consistent for each user tracking meal information.

Put those values in a map, and give that to `Nutritionix.client/1` like so:

```elixir
{:ok, client} = Nutritionix.client(%{app_id: app_id, app_key: app_key, user_id: person.id})
```

There's also `Nutritionix.client!/1` for if you want the client without the tuple around it.

### Natural language parsing of meal descriptions

Pass the client and the meal description to `Nutritionix.parse_description/2`:

```elixir
{:ok, response} = Nutritionix.parse_description(client, "steak, eggs, a cup of coffee")
```

The response will have a `"body"`, which will have a `"foods"` list. For full details, see the `Nutritionix.parse_description/2` docs.

### Searching for meal ingredients

To search for ingredients to add to a meal, use `Nutritionix.ingredient_search/2`. This is intended to be used as an autocomplete mechanism for a search box.

```elixir
{:ok, response} = Nutritionix.ingredient_search(client, "baco") 
```

The response will have a `"body"` which will have a `"branded"` list and a `"common"` list. Branded foods are actual brand name items, and can be looked up via their `"nix_item_id"` value. Common foods are generic foods (think "grapes" or "white bread") and can be looked up by calling `parse_description/2` with the `"food_name"` value.

#### Looking up Branded foods

As above, pass the `"nix_item_id"` value into `search_branded/2`:

```elixir
Nutritionix.search_branded(client, "51db37b7176fe9790a898a66")
```

#### Looking up Common foods

As above, pass the `"food_name"` value into `search_common/2`:

```elixir
Nutritionix.search_common(client, "grapes")
```

The `Nutritionix.search_common/2` function is an alias for `parse_description/2` as the Nutritionix API uses the same endpoint to handle NLP parsing of descriptions, and simply returning common food details by name.

If you'd rather ignore this and make the client code clear that the same endpoint is called for both operations, feel free to use `parse_description/2` everywhere.