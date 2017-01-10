defmodule Sesamex.Model do
  import Ecto.Changeset
  import Sesamex.Model.Validation


  @moduledoc """
  """


  @doc """
  """
  @spec changeset(Tuple.t, Tuple.t) :: Tuple.t
  def changeset(model, params \\ :empty) do
    changeset(model, params, [:email])
  end

  @spec changeset(Tuple.t, Tuple.t, Keyword.t) :: Tuple.t
  def changeset(model, params, opts) do
    cast_fields = Keyword.fetch!(opts, :cast)

    model
    |> cast(params, cast_fields)
    |> unique_constraint(:email)
  end


  @doc """
  """
  @spec registration_changeset(Tuple.t, Tuple.t) :: Tuple.t
  def registration_changeset(model, params) do
    registration_changeset(model, params, password_length: [min: 6, max: 100])
  end

  @spec registration_changeset(Tuple.t, Tuple.t, Keyword.t) :: Tuple.t
  def registration_changeset(model, params, opts) do
    password_length = Keyword.fetch!(opts, :password_length)

    model
    |> changeset(params)
    |> cast(params, [:password, :password_confirmation])
    |> validate_length(:password, password_length)
    |> validate_password_confirmation
    |> encrypt_password
  end


  @spec encrypt_password(Tuple.t) :: Tuple.t
  defp encrypt_password(model) do
    case model do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(model, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        model
    end
  end


  defmacro __using__([]) do
    quote do
      import Sesamex.Model
    end
  end
end
