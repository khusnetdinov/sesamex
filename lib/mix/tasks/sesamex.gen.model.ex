defmodule Mix.Tasks.Sesamex.Gen.Model do
  use Mix.Task

  import Sesamex.Helpers

  require EEx


  @files [:model, :migration]

  EEx.function_from_file :defp, :model_template,
    "priv/templates/sesamex.gen/model.eex", [:module, :base, :plural]
  EEx.function_from_file :defp, :migration_template,
    "priv/templates/sesamex.gen/migration.eex", [:module, :base, :plural]


  @spec run(List.t) :: none()
  def run([singular, plural]) do
    bindings = Mix.Phoenix.inflect(singular)

    migration = migration_template(bindings[:base], bindings[:scoped], plural)
    create_file_from(migration, "priv/repo/migrations/#{timestamp}_create_#{bindings[:path]}.exs")

    model = model_template(bindings[:base], bindings[:scoped], plural)
    create_file_from(model, "web/models/#{bindings[:path]}.ex")
  end
end
