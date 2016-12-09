# Sesamex [WIP] [![Build Status](https://travis-ci.org/khusnetdinov/sesamex.svg?branch=master)](https://travis-ci.org/khusnetdinov/sesamex)

![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/v1477049798/147705061811651_leoa8a.jpg)

## Getting started

Sesamex is a flexible authentication solution for Elixir / Phoenix. Functionality is devided to several modules:

## Installation

Add `sesamex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:sesamex, "~> 0.1.0"}]
end
```

## Usage

### Create resource model

You need create model or add to exist fields for using them for authenticetion. For generation use mix task:

```elixir
$ mix sesamex.gen.model User users
```

It will create 2 files:
  - `web/models/user.ex`
  - `priv/repo/migrations/#{timestamp}_create_user.ex`
  
After don't forget run ecto migration.

If you need to add fields to exist model see [model.eex](https://github.com/khusnetdinov/sesamex/blob/resource_model/priv/templates/sesamex.gen/model.eex) and
[migration.eex](https://github.com/khusnetdinov/sesamex/blob/master/priv/templates/sesamex.gen/migration.eex)

[Read more]()

### Setting up routes

Fou need define `resource` for authentication requests. Use `Sesamex.Routes` module for this purpose. Rsource should be in plural form. See examle below:

```elixir
defmodule Project.Routes do
  use Project.Web, :routes
  use Sesamex.Routes

  # ...

  scope "/", Project do
    pipe_through :browser
    authenticate :users

    # ...

    get "/", PageController, :index
  end

  # ...

end
```

[Read more]()

## Modules

### Sesamex.Routes

Add to Routes module `authentiate: 2` macros which create additional routes for `resource` and each functional module.
It acceps `resource` in plural form.
For constrain modules that you want to use pass to helper:

  * only: [:module, :other_module] - Only for this modules will be generated routes;

  * expect: [:module, :other_module] - Except this modules will be generated routes;

By default macros generate routes for controllers which shoud be defined
by user in resource scope with module name, see example:

```elixir

  authenticate :users, only: [:registration]

  # Generate routes
  # user_registration_path  GET  /users/sign_up  Project.User.RegistrationController :new
  # ...

```

If you want to redifine controller name, use `controllers` Keywords list:

 * controllers: [module: OtherController] - Redefine controllers for module.

```elixir

  authenticate :users, controllers: [registration: OtherController]

  # Generate routes
  # user_registration_path  GET  /users/sign_up  Project.OtherController :new
  # ...

```

## Tasks

### TODO: Sesamex.Gen.Model

## TODO: Usage

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
