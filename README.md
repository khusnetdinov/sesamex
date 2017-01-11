# [WIP] Sesamex [![Code Triagers Badge](https://www.codetriage.com/khusnetdinov/sesamex/badges/users.svg)](https://www.codetriage.com/khusnetdinov/sesamex) [![Build Status](https://travis-ci.org/khusnetdinov/sesamex.svg?branch=master)](https://travis-ci.org/khusnetdinov/sesamex) [![Ebert](https://ebertapp.io/github/khusnetdinov/sesamex.svg)](https://ebertapp.io/github/khusnetdinov/sesamex) [![Hex.pm](https://img.shields.io/hexpm/v/plug.svg)](https://hex.pm/packages/sesamex)
![img](http://res.cloudinary.com/dtoqqxqjv/image/upload/v1477049798/147705061811651_leoa8a.jpg)

# NOTE: This repo in active development!


## Getting started

Sesamex is a simple and flexible authentication solution for Elixir / Phoenix.

#### Implemented functionality:

- `:registration`
- `:session`

#### Todo functionality:

- `:remember`
- `:track`
- email adapter
- email in browser
- `:confirm`
- `:recover`
- `:invite`
- `:lock, :unlock`
- token auth
- `:oauth`
- change layout

## Installation

Add `sesamex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:sesamex, "~> 0.2.1"}]
end
```

## Authentication in 5 minutes!

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
$ mix sesamex.gen.routes User
```

7) Add routes functions to `layout.html.eex`, remove lines with `Get Started` link and paste code below.

```elixir
<%= if @current_user do %>
  <li><%= @current_user.email %></li>
  <li><%= link "sign_out", to: session_path(@conn, :delete), method: "delete" %>
<% else %>
  <li><%= link "sign_up", to: registration_path(@conn, :new) %></li>
  <li><%= link "sign_in", to: session_path(@conn, :new) %></li>
<% end %>
```

8) Run server `mix phoenix.server`.

## Usage

Sesamex goes with helper modules which keep required logic for authentification.

#### Generate model and migration for authentication process:

```elixir
$ mix sesamex.gen.model Model models
```

The tasks accepts the same argements as phoenix model generation task - singular and plural forms of model.
Task will generate 2 files:

- `web/models/model.ex`
- `priv/repo/migrations/#{timestamp}_create_model.ex`

Model file keeps schema and changesets functions which were taken from `Sesamex.Model` by default. If you want customize, just write you own logic.

By default Sesamex use `email`, `password` fields for authentication. If you want to change them or add additional fields you need to change migration and schema in this files.

#### Generate predefined controllers modules for model scope:

```elixir
$ mix sesamex.gen.controllers Model
```

Task get `Model` in singular form for defining controllers modules scope and generate files. In example:
```
├── controllers/
│   ├── model/
│   │   ...
│   │   └── registration_controller.ex
│   └── page_controller.ex
```

By defualt sesamex generate controllers with scope `Project.Model.ExampleController`. If you want to use custom controllers you need change settings in routes. See below.

#### Generation predefined views modules for model scope:

```elixir
$ mix sesamex.gen.views Model
```

Task do the job like controllers task for views.

#### Generation predefined templates for `sign_up`, `sign_in` pages:

```elixir
$ mix sesames.gen.templates Model
```

Task get `Model` scope name and create templates for pages:

- `web/templates/model/registration/new.html.eex`
- `web/templates/model/session/new.html.eex`

Templates file keep predefined eex markup for using pages instantly.

#### Generation routes and define default controllers:

```elixir
$ mix sesamex.gen.routes Model
```

Adds to `web/routex.ex` Sesamex modules and helpers:

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

Module `Sesamex.Routes` macro `authenticate: 2` keep logic for generation route_paths for model. Note that you should atom in plural form `:models`. There are 2 opts `only`, `except`, see examples:

- `only: [:module, :other_module]`
- `except: [:module, :other_module]`

By default macros generate routes for controllers which shoud be scoped by model name, see example:

```elixir

  authenticate :users, only: [:registration]

  # Generate routes
  # registration_path  GET  /users/sign_up  Project.User.RegistrationController :new
  # ...

```

If you want to redifine controller name, use `controllers` Keywords list:

- controllers: [module: OtherController] - Redefine controllers for module.

```elixir

  authenticate :users, controllers: [registration: OtherController]

  # Generate routes
  # registration_path  GET  /users/sign_up  Project.OtherController :new
  # ...

```

#### Generation current model assigns in @conn:

Sesamex add to @conn `current_model` assigns for `Model`. You can use `@corrent_model` in views for checking persistance of authenticated model.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
