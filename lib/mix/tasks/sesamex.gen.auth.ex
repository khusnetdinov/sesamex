defmodule Mix.Tasks.Sesamex.Gen.Auth do
  use Mix.Task

  import Loki.Cmd
  import Loki.Shell

  @spec run(List.t) :: none()
  def run([singular, plural]) do

    execute("mix sesamex.gen.model #{singular} #{plural}")
    execute("mix sesamex.gen.controllers #{singular}")
    execute("mix sesamex.gen.views #{singular}")
    execute("mix sesamex.gen.templates #{singular}")
    execute("mix sesamex.gen.routes #{singular}")

    say """

Sesamex setted up authenticaton for #{singular} model!
Just migrate database:

        $ mix ecto.migrate

And run server:

        $ mix phoenix.server
    """
  end
end

