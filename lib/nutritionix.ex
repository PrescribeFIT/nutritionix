defmodule Nutritionix do
  @moduledoc """
  API for interacting with the Nutritionix API.

  https://www.nutritionix.com/ for more details.
  """

  # Get a client for the Nutritionix service.
  #
  # Clients require a user identifier to distinguish one user from another.
  # This identifer can be anything, so long as it is consistent.
  #
  ## Examples
  #
  # iex> Nutritionix.client("userid")
  # Tesla.client{}
  #
  @spec client(String.t()) :: Tesla.Client.t()
  def client(user_id) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://trackapi.nutritionix.com"},
      {Tesla.Middleware.Headers,
       [{"x-app-id", ""}, {"x-app-key", ""}, {"x-remote-user-id", user_id}]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
