defmodule Sesamex.Pipeline do
  import Plug.Conn


  @moduledoc """
  """


  @doc """
  """
  @spec session(Tuple.t, List.t) :: Tuple.t
  def session(conn, [resource, model, repo]) do
    session(conn, resource, model, repo)
  end

  @spec session(Tuple.t, Keyword.t) :: Tuple.t
  def session(conn, opts) do
    resource = Keyword.fetch!(opts, :resource)
    model = Keyword.fetch!(opts, :model)
    repo = Keyword.fetch!(opts, :repo)

    session(conn, resource, model, repo)
  end

  @spec session(Tuple.t, Atom.t, module(), module())  :: Tuple.t
  def session(conn, resource_name, model, repo) do
    resource_id = get_session(conn, :"#{resource_name}_id")
    resource = resource_id && repo.get(model, resource_id)

    assign(conn, :"current_#{resource_name}", resource)
  end


  defmacro __using__([]) do
    quote do
      import Sesamex.Pipeline
    end
  end
end
