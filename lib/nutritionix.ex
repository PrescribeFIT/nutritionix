defmodule Nutritionix do
  @moduledoc """
  API for interacting with the Nutritionix API.

  https://www.nutritionix.com/ for more details.
  """
  @nutritionix_api_baseurl "https://trackapi.nutritionix.com"

  @doc """
  Lookup
  """
  def ingredient_search(client, term) do
    Tesla.get(client, "/v2/search/instant", query: [query: term])
  end

  @spec client([{:app_id, String.t()} | {:app_key, String.t()} | {:user_id, String.t()}, ...]) ::
          {:ok, Tesla.Client.t()} | {:error, String.t()}
  @doc """
  Get a client for the Nutritionix service.

  The Nutritionix API requires a user identifier to distinguish one user from
  another.

  ## Examples

      iex> {:ok, %Tesla.Client{}} = Nutritionix.client(user_id: "userid",
      ...>                                             app_key: "key",
      ...>                                             app_id: "id")
  """
  def client(user_id: user_id, app_key: app_key, app_id: app_id) do
    try do
      {:ok, client!(user_id: user_id, app_key: app_key, app_id: app_id)}
    rescue
      e ->
        {:error, e.message}
    end
  end

  @spec client!([{:app_id, String.t()} | {:app_key, String.t()} | {:user_id, String.t()}, ...]) ::
          Tesla.Client.t()
  @doc """
  Get a client for the Nutritionix service (directly, no tuple)

  See client/1 for the function you probably want.

  ## Examples

      iex> %Tesla.Client{} = Nutritionix.client!(user_id: "userid",
      ...>                                       app_key: "key",
      ...>                                       app_id: "id")
  """
  def client!(user_id: user_id, app_key: app_key, app_id: app_id) do
    middleware = [
      {Tesla.Middleware.BaseUrl, @nutritionix_api_baseurl},
      {Tesla.Middleware.Headers,
       [{"x-app-id", app_id}, {"x-app-key", app_key}, {"x-remote-user-id", user_id}]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
