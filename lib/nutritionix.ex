defmodule Nutritionix do
  @moduledoc """
  API for interacting with the Nutritionix API.

  https://www.nutritionix.com/ for more details.
  """
  @nutritionix_api_baseurl "https://trackapi.nutritionix.com"

  @doc """
  Get a client for the Nutritionix service.

  The Nutritionix API requires a user identifier to distinguish one user from
  another.

  ## Examples

      iex> {:ok, %Tesla.Client{}} = Nutritionix.client("userid")
  """
  @spec client(String.t()) :: {:ok, Tesla.Client.t()}
  def client(user_id) do
    try do
      {:ok, client!(user_id)}
    rescue
      e ->
        {:error, e.message}
    end
  end

  @doc """
  Get a client for the Nutritionix service (directly, no tuple)

  See client/1 for the function you probably want.

  ## Examples

      iex> %Tesla.Client{} = Nutritionix.client!("userid")
  """
  @spec client!(String.t()) :: Tesla.Client.t()
  def client!(user_id) do
    app_id = System.fetch_env!("NUTRITIONIX_APP_ID")
    app_key = System.fetch_env!("NUTRITIONIX_APP_KEY")

    middleware = [
      {Tesla.Middleware.BaseUrl, @nutritionix_api_baseurl},
      {Tesla.Middleware.Headers,
       [{"x-app-id", app_id}, {"x-app-key", app_key}, {"x-remote-user-id", user_id}]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
