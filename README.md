# Sesamex [WIP] [![Code Triagers Badge](https://www.codetriage.com/khusnetdinov/sesamex/badges/users.svg)](https://www.codetriage.com/khusnetdinov/sesamex)[![Build Status](https://travis-ci.org/khusnetdinov/sesamex.svg?branch=master)](https://travis-ci.org/khusnetdinov/sesamex)[![Ebert](https://ebertapp.io/github/khusnetdinov/sesamex.svg)](https://ebertapp.io/github/khusnetdinov/sesamex) [![Hex.pm](https://img.shields.io/hexpm/v/plug.svg)](https://hex.pm/packages/sesamex)
![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/v1477049798/147705061811651_leoa8a.jpg)


## Getting started

Sesamex are a simple and flexible authentication solution for Elixir / Phoenix.

## Installation

Add `sesamex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:sesamex, "~> 0.2.0"}]
end
```

## Usage

### Fast start: authentication in 5 minutes!

We are going to create authentication for `User` model in 5 minutes with `phoenix.new` bootstrapped application. 

1) Create model and migration for `User`.

```elixir
$ mix sesamex.gen.model User users
```

2) Migrate database.

```elixir
$ mix ecto.migrate
```

3) Create predefined controllers for using them in authentication.

```elixir
$ mix sesamex.gen.controllers User
```

4) Create predefined views modules.

```elixir
$ mix sesamex.gen.views User
```

5) Create predefined templates for sign_up and sign_in pages.
 
```elixir
$ mix sesamex.gen.templates User
```

6) Add routes modules `Sesamex.Routes`, `Sesamex.Pipeline` and functions `authenticate`, `session`.

```elixir
defmodule Project.Routes do
  # ...
  use Sesamex.Routes
  use Sesamex.Pipeline
  
  alias Project.Repo
  alias Project.User
  
  pipeline :browser do
    # ...
    plug :session, [:user, User, Repo]
  end

  scope "/", Project do
    # ...
    authenticate :users
    
    get "/", PageController, :index
  end
  # ...
end
```

7) Add routes functions to `layout.html.eex`, remove lines with `Get Started` link and paste code below.

```elixir
<%=​ ​if​ @current_user ​do​ ​%>​
  <li>​<%=​ @current_user.email ​%>​</li>
​  <li><%=​ link ​"​​sign_out"​, ​to:​ session_path(@conn, ​:delete​, @current_user), ​​method:​ ​"​​delete"​ ​%>​
​​<%​ ​else​ ​%>​
​  <li>​<%=​ link ​"​​sign_up"​, ​to:​ registration_path(@conn, ​:new​) ​%>​</li>
​  <li>​<%=​ link ​"​​sign_in"​, ​to:​ session_path(@conn, ​:new​) ​%>​</li>
​​<%​ ​end​ ​%>​
```

8) Run server `mix phoenix.server`.


### Create resource model

You need create model or add to exist fields for using them for authenticetion. For generation use mix task:

```elixir
$ mix sesamex.gen.model User users
```

It will create 2 files:
  - `web/models/user.ex`
  - `priv/repo/migrations/#{timestamp}_create_user.ex`
  
After don't forget run ecto migration. If you need to add fields to exist model see [model.eex](https://github.com/khusnetdinov/sesamex/blob/resource_model/priv/templates/sesamex.gen/model.eex) and
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
