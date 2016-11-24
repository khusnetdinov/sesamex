defmodule Sesamex.Routes do
  use Phoenix.Router

  import Inflex, only: [singularize: 1]

  @moduledoc """
  TODO: Description
  """

  @modules [:registration]

  @doc """
  TODO: Description
  """
  defmacro authenticate(resources_name, opts \\ []) when is_atom(resources_name) do
    modules = required_modules(opts)
    resources = Atom.to_string(resources_name)

    modules_routes(resources, modules)
  end

  @doc false
  defp required_modules(modules) do
    if only = Keyword.get(modules, :only) do
      @modules -- (@modules -- only)
    else
      @modules -- Keyword.get(modules, :except, [])
    end
  end

  @doc false
  defp modules_routes(resources, modules) do
    resource = singularize(resources)

    quote do
      scope "/#{unquote(resources)}" do
        if Enum.member?(unquote(modules), :registration) do
          unquote(define_registration_routes_for(resource))
        end
      end
    end
  end

  @doc false
  defp define_registration_routes_for(resource) do
    controller = define_controller(:registration, resource)
    routes_path = define_routes_path(:registration, resource)

    quote bind_quoted: [controller: controller, routes_path: routes_path] do
      get "/sign_up", controller, :new, as: routes_path
      post "/sign_up", controller, :create, as: routes_path
    end
  end

  @doc false
  defp define_controller(module, resource) do
    scope = String.capitalize(resource)
    controller_name = String.capitalize(Atom.to_string(module))

    {:__aliases__, [alias: false], [:"#{scope}.#{controller_name}Controller"]}
  end

  @doc false
  defp define_routes_path(module, resource) do
    "#{resource}_#{module}"
  end

  @doc """
  TODO: Description
  """
  defmacro __using__([]) do
    quote do
      import Sesamex.Routes
    end
  end
end
