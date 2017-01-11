defmodule Mix.Tasks.Sesamex.Gen.Views do
  use Mix.Task

  import Sesamex
  import Sesamex.Helpers

  require EEx


  EEx.function_from_file :defp, :view_template,
    "priv/templates/sesamex.gen/view.eex", [:base, :scoped, :view]


  @spec run(List.t) :: none()
  def run([]) do
    IO.puts "Please provide model name"
  end

  @spec run(List.t) :: none()
  def run([singular]) do
    bindings = Mix.Phoenix.inflect(singular)

    create_directory_unless_exist("web/views/#{bindings[:path]}")

    Enum.each(modules, fn(file) ->
      view = view_template(bindings[:base], bindings[:scoped], String.capitalize("#{file}"))
      path ="web/views/#{bindings[:path]}/#{file}_view.ex"
      create_file_from(view, path)
    end)
  end
end
