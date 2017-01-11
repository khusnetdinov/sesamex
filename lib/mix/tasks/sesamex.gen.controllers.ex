defmodule Mix.Tasks.Sesamex.Gen.Controllers do
  use Mix.Task

  import Sesamex
  import Sesamex.Helpers

  require EEx


  EEx.function_from_file :def, :registration_template,
    "priv/templates/sesamex.gen/controllers/registration.eex", [:base, :scoped, :singular, :controller]
  EEx.function_from_file :def, :session_template,
    "priv/templates/sesamex.gen/controllers/session.eex", [:base, :scoped, :singular, :controller]


  @spec run(List.t) :: none()
  def run([]) do
    IO.puts "Please provide model name!"
  end

  @spec run(List.t) :: none()
  def run([singular]) do
    bindings = Mix.Phoenix.inflect(singular)

    create_directory_unless_exist("web/controllers/#{bindings[:path]}")

    Enum.each(templates(bindings), fn({file, template}) ->
      create_file_from(template, "web/controllers/#{bindings[:path]}/#{file}_controller.ex")
    end)
  end


  @spec templates(Tuple.t) :: none()
  defp templates(bindings) do
    Enum.map(modules, fn(file) ->
      {file, apply(__MODULE__, :"#{file}_template", [bindings[:base], bindings[:scoped], bindings[:singular], String.capitalize("#{file}")])}
    end)
  end
end
