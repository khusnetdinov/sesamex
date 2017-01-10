defmodule Mix.Tasks.Sesamex.Gen.Templates do
  use Mix.Task

  import Sesamex
  import Sesamex.Helpers

  require EEx


  @moduledoc """
  """

  @files [registration: [:new], session: [:new]]

  EEx.function_from_file :def, :registration_new_template,
    "priv/templates/sesamex.gen/templates/registration/new.eex", []
  EEx.function_from_file :def, :session_new_template,
    "priv/templates/sesamex.gen/templates/session/new.eex", []


  @doc """
  """
  @spec run(List.t) :: none()
  def run([]) do
    IO.puts "Please provide model name!"
  end

  @spec run(List.t) :: none()
  def run([singular]) do
    bindings = Mix.Phoenix.inflect(singular)

    source_directory = "web/templates/#{bindings[:path]}"
    create_directory_unless_exist(source_directory)

    Enum.each(modules, fn(source) ->
      create_directory_unless_exist("#{source_directory}/#{source}")
      template = apply(__MODULE__, :"#{source}_new_template", [])
      create_file_from(template, "#{source_directory}/#{source}/new.html.eex")
    end)
  end
end
