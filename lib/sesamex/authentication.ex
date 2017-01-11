defmodule Sesamex.Authentication do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]


  @moduledoc """
  Handle authentication methods for signing in and signing out.
  """


  @doc """
  Authenticate resource.
  """
  @spec sign_in(Tuple.t, Atom.t, any) :: Tuple.t
  def sign_in(conn, resource_name, model) do
    conn
    |> assign(:"current_#{resource_name}", model)
    |> put_session(:"#{resource_name}_id", model.id)
    |> configure_session(renew: true)
  end


  @doc """
  Authenticate resource by `:email` and `:password`.
  """
  @spec sign_in_by_email_and_password(Tuple.t, String.t, String.t, List.t) :: Tuple.t
  def sign_in_by_email_and_password(conn, email, password, [resource_name, model, repo]) do
    sign_in_by_email_and_password(conn, email, password, resource_name, model, repo)
  end

  @spec sign_in_by_email_and_password(Tuple.t, String.t, String.t, Keyword.t) :: Tuple.t
  def sign_in_by_email_and_password(conn, email, password, opts) do
    resource_name = Keyword.fetch!(opts, :resource)
    model = Keyword.fetch!(opts, :model)
    repo = Keyword.fetch!(opts, :repo)

    sign_in_by_email_and_password(conn, email, password, resource_name, model, repo)
  end

  @spec sign_in_by_email_and_password(Tuple.t, String.t, String.t, Atom.t, module(), module()) :: Tuple.t
  def sign_in_by_email_and_password(conn, email, password, resource_name, model, repo) do
    model = repo.get_by(model, email: email)

    cond do
      model && checkpw(password, model.encrypted_password) ->
        {:ok, sign_in(conn, resource_name, model)}
      model ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end


  @doc """
  Drop authenticated session.
  """
  @spec sign_out(Tuple.t) :: Tuple.t
  def sign_out(conn) do
    configure_session(conn, drop: true)
  end


  defmacro __using__(_opts) do
    quote do
      import Sesamex.Authentication
    end
  end
end
