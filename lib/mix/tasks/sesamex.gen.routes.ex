defmodule Mix.Tasks.Sesamex.Gen.Routes do
  use Mix.Task

  import Loki.FileManipulation
  import Inflex, only: [pluralize: 1]


  @spec run(List.t) :: none()
  def run([singular]) do
    bindings = Mix.Phoenix.inflect(singular)

    routes_path = "web/router.ex"

    inject_modules_import(routes_path, bindings)
    inject_session_plug(routes_path, bindings)
    inject_authenticate_model(routes_path, bindings)
  end


  @spec inject_modules_import(Path.t, Tuple.t) :: none()
  defp inject_modules_import(path, bindings) do
    import_modules = "  use Sesamex.Routes\n  use Sesamex.Pipeline\n"
    string = "  use #{bindings[:base]}.Web, :router"

    inject_into_file(path, import_modules, :after, string)
  end


  @spec inject_session_plug(Path.t, Tuple.t) :: none()
  defp inject_session_plug(path, bindings) do
    session_plug = "    plug :session, [:#{bindings[:singular]}, #{bindings[:module]}, #{bindings[:base]}.Repo]"
    string = "    plug :put_secure_browser_headers"

    inject_into_file(path, session_plug, :after, string)
  end

  @spec inject_authenticate_model(Path.t, Tuple.t) :: none()
  defp inject_authenticate_model(path, bindings) do
    authentication_model = "    authenticate :#{pluralize(bindings[:singular])}"
    string = "    pipe_through :browser # Use the default browser stack"

    inject_into_file(path, authentication_model, :after, string)
  end
end
