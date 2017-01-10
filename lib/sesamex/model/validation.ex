defmodule Sesamex.Model.Validation do
  import Ecto.Changeset


  @moduledoc """
  """


  @doc """
  """
  @spec validate_password_confirmation(Tuple.t) :: Tuple.t
  def validate_password_confirmation(changeset) do
    validate_password_confirmation(changeset, "Invalid email or password.")
  end

  @spec validate_password_confirmation(Tuple.t, String.t) :: Tuple.t
  def validate_password_confirmation(changeset, error_message) do
    password = get_field(changeset, :password)
    password_confirmation = get_field(changeset, :password_confirmation)

    if password_confirmation == password do
      changeset
    else
      add_error(changeset, :password_confirmation, error_message)
    end
  end


  defmacro __using__([]) do
    quote do
      import Sesamex.Model.Validation
    end
  end
end
