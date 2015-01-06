defmodule Fawlty.View do
  use Phoenix.View, root: "web/templates"

  # The quoted expression returned by this block is applied
  # to this module and all other views that use this module.
  using do
    quote do
      # Import common functionality
      import Fawlty.Router.Helpers

      # Use Phoenix.HTML to import all HTML functions (forms, tags, etc)
      use Phoenix.HTML

      # Common aliases
      alias Phoenix.Controller.Flash
    end
  end

  # Functions defined here are available to all other views/templates
  def user_session(conn) do
    Fawlty.Devise.get_session(conn)
  end

  def debug(conn) do
    "#{inspect Fawlty.Devise.get_session(conn)}"
  end
end
