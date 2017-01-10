defmodule Sesamex.Routes do
  use Phoenix.Router

  import Sesamex
  import Inflex, only: [singularize: 1]


  @moduledoc """
  """


  @doc """
  """
  defmacro authenticate(resources_name, opts \\ []) when is_atom(resources_name) do
    modules = required_modules(opts)
    controllers = predefined_controllers(opts)
    resources = Atom.to_string(resources_name)

    modules_routes(resources, modules, controllers)
  end


  @spec predefined_controllers(Keyword.t) :: List.t
  defp predefined_controllers(opts), do: Keyword.get(opts, :controllers, [])


  @spec modules_routes(String.t, List.t, List.t) :: Tuple.t
  defp modules_routes(resources, modules, predefined_controllers) do
    resource = singularize(resources)

    quote do
      if Enum.member?(unquote(modules), :registration) do
        unquote(define_registration_routes_for(resource, predefined_controllers))
        unquote(define_session_routes_for(resource, predefined_controllers))
      end
    end
  end


  @spec define_registration_routes_for(String.t, List.t) :: Tuple.t
  defp define_registration_routes_for(resource, predefined_controllers) do
    [controller, routes_path] = define_names(:registration, resource, predefined_controllers)

    quote bind_quoted: [controller: controller, routes_path: routes_path, resource: resource] do
      get "/users/sign_up", controller, :new, as: routes_path
      post "/users/sign_up", controller, :create, as: routes_path
    end
  end


  @spec define_session_routes_for(String.t, List.t) :: Tuple.t
  defp define_session_routes_for(resource, predefined_controllers) do
    [controller, routes_path] = define_names(:session, resource, predefined_controllers)

    quote bind_quoted: [controller: controller, routes_path: routes_path, resource: resource] do
      get "/users/sign_in", controller, :new, as: routes_path
      post "/users/sign_in", controller, :create, as: routes_path
      delete "/users/sign_out", controller, :delete, as: routes_path
    end
  end


  @spec define_names(Atom.t, String.t, List.t) :: Tuple.t
  defp define_names(name, resource, predefined_controllers) do
    predefined_name = Keyword.get(predefined_controllers, name, nil)
    controller = define_controller(name, resource, predefined_name)
    routes_path = define_routes_path(name, resource)

    [controller, routes_path]
  end


  @spec define_controller(String.t, String.t, String.t) :: Tuple.t
  defp define_controller(module, resource, predefined_name) do
    scope = String.capitalize(resource)
    controller_name = String.capitalize(Atom.to_string(module))

    case predefined_name do
      nil -> {:__aliases__, [alias: false], [:"#{scope}.#{controller_name}Controller"]}
      predefined_name -> {:__aliases__, [alias: false], [predefined_name]}
    end
  end


  @spec define_routes_path(String.t, String.t) :: String.t
  defp define_routes_path(module, resource), do: "#{resource}_#{module}"


  defmacro __using__([]) do
    quote do
      import Sesamex.Routes
    end
  end
end
