defmodule Fawlty.PageController do
  use Phoenix.Controller

  plug :action

  @doc """
  Display the index page for the application.
  """
  def index(conn, _params) do
    render conn, :index
  end

  def not_found(conn, _params) do
    render conn, :not_found
  end

  def error(conn, _params) do
    render conn, :error
  end
end
