defmodule Sesames.Mixfile do
  use Mix.Project

  def project do
    [app: :sesamex,
     version: "0.2.1",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    []
  end

  defp description do
    """
    Sesamex is a simple and flexible authentication solution for Elixir / Phoenix.
    """
  end

  defp package do
    [
      name: :sesamex,
      files: ~w(lib) ++
             ~w(LICENSE README.md mix.exs),
      maintainers: ["Marat Khusnetdinov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/khusnetdinov/sesamex"}
    ]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:inflex, "~> 1.7.0" },
     {:ecto, "~> 2.1.0"},
     {:comeonin, "~> 2.0"},
     {:loki, "~> 1.1.0"},
     {:phoenix, "~> 1.2.1"}]
  end
end
