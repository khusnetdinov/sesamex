defmodule Sesamex do

  @moduledoc """
  Sesamex provide simple and flexible authentication solution for Elixir / Phoenix.

  It includes:

    * `Sesamex.Authenticate` - Handle authentication methods for signing in and signing out.

    * `Sesamex.Helpers` - Reusable helpers for sesamex.

    * `Sesamex.Model` - Collection Model functions for keep simple atuhentication.

    * `Sesamex.Pipeline` - Keep authentication pipeline methods.

    * `Sesamex.Routes` - Routes generators for model.


  """


  @modules [:registration, :session]


  @doc """
  Returns all modules.
  """
  @spec modules() :: List.t
  def modules(), do: @modules


  @doc """
  Returns desired modules. Use `:only` or `:except` options.
  """
  @spec required_modules(Keyword.t) :: List.t
  def required_modules(opts) do
    if only = Keyword.get(opts, :only) do
      modules -- (modules -- only)
    else
      modules -- Keyword.get(opts, :except, [])
    end
  end
end
