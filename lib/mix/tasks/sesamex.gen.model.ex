defmodule Mix.Tasks.Sesamex.Gen.Model do
  use Mix.Task

  import Mix.Sesamex
  import Loki.File
  import Loki.Shell

  require EEx

  @moduledoc """
  """

  EEx.function_from_file :defp, :model_template,  "priv/templates/sesamex.gen/model.eex", [:module, :base, :plural]
  EEx.function_from_file :defp, :migration_template,  "priv/templates/sesamex.gen/migration.eex", [:module, :base, :plural]

  @doc """
  """
  def run([]) do
    IO.puts "Please provide model!"
  end

  @doc false
  def run([singular, plural]) do
    bindings = Mix.Phoenix.inflect(singular)

    model = model_template(bindings[:base], bindings[:scoped], plural)
    migration = migration_template(bindings[:base], bindings[:scoped], plural)

    model_path = "web/models/#{bindings[:path]}.ex"
    migration_path = "priv/repo/migrations/#{timestamp}_create_#{bindings[:path]}.exs"


    if exists_file? model_path do
      if identical_file?(model_path, model) do
        say_identic("#{model_path}")
      else
        say_exists("#{model_path}")
        create_file_force_or_skip(model_path, model)
      end
    else
      create_file(model_path, model)
    end

    create_file(migration_path, migration)
  end
end
