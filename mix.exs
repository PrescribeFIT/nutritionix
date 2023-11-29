defmodule Nutritionix.MixProject do
  use Mix.Project

  def project do
    [
      app: :nutritionix,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.8"},
      {:jason, "~> 1.4"}
    ]
  end
end
