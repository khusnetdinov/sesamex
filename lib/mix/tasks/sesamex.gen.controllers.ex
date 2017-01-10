defmodule Mix.Tasks.Sesamex.Gen.Controllers do
  use Mix.Task

  import Sesamex
  import Sesamex.Helpers

  require EEx


  @moduledoc """
  """


  EEx.function_from_file :def, :registration_template,
    "priv/templates/sesamex.gen/controllers/registration.eex", [:base, :scoped, :singular, :controller]
  EEx.function_from_file :def, :session_template,
    "priv/templates/sesamex.gen/controllers/session.eex", [:base, :scoped, :singular, :controller]


  @doc """
  """
  def run([]) do
    IO.puts "Please provide model name!"
  end

  def run([singular]) do
    bindings = Mix.Phoenix.inflect(singular)

    create_directory_unless_exist("web/controllers/#{bindings[:path]}")

    Enum.each(templates(bindings), fn({file, template}) ->
      create_file_from(template, "web/controllers/#{bindings[:path]}/#{file}_controller.ex")
    end)
  end


  defp templates(bindings) do
    Enum.map(modules, fn(controller) ->
      {controller, apply(__MODULE__, :"#{controller}_template", [bindings[:base], bindings[:scoped], bindings[:singular], String.capitalize("#{controller}")])}
    end)
  end
end
