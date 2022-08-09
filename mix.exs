defmodule Nutritionix.MixProject do
  use Mix.Project

  def project do
    [
      app: :nutritionix,
      version: "0.1.0",
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
      {:tesla, "~> 1.4.4"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:jason, "~> 1.3"}
    ]
  end
end
