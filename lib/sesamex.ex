defmodule Sesamex do

  @moduledoc """
  """


  @modules [:registration, :session]


  @doc """
  """
  @spec modules() :: List.t
  def modules(), do: @modules


  @doc """
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
