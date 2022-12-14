defmodule MarkerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MarkerWeb, :controller
      use MarkerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  use Boundary, deps: [Marker, Phoenix, Ecto.Changeset], exports: [Endpoint]

  def controller do
    quote do
      use Phoenix.Controller, namespace: MarkerWeb

      import Plug.Conn
      import MarkerWeb.Gettext
      alias MarkerWeb.Router.Helpers, as: Routes
    end
  end

  def view(opts \\ []) do
    # See https://elixirforum.com/t/domain-oriented-web-folder-structure/16671/2
    # and https://hexdocs.pm/phoenix_view/1.1.2/Phoenix.View.html
    opts =
      opts
      |> Keyword.put_new(:namespace, MarkerWeb)
      |> Keyword.put_new(:root, "lib/marker_web/")

    opts =
      case Keyword.get(opts, :root_ext) do
        nil -> opts
        ext -> opts |> Keyword.update!(:root, &Path.join(&1, ext))
      end

    quote do
      use Phoenix.View, unquote(opts)

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {MarkerWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MarkerWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers
      import MarkerWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import MarkerWeb.ErrorHelpers
      import MarkerWeb.Gettext
      alias MarkerWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__({which, opts}) when is_atom(which) do
    apply(__MODULE__, which, [opts])
  end
end
