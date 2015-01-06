defmodule Fawlty.SessionsController do
  use Phoenix.Controller

  plug :action

  @moduledoc """
  Controller for session validation, creation and destruction.
  """

  @type conn   :: %Plug.Conn{}

  alias Fawlty.Devise
  alias Fawlty.Oauth2Lib

  ####
  # Router Actions

  @doc """
  Redirect the request to the google authentication service.
  """
  def google_oauth2(conn, params) do
    redirect(conn, external: Oauth2Lib.authorized_url)
  end

  @doc """
  Receives the response from the google authentication service and validates the token to
  allow or disallow a session.
  * Valid sessions are redirect to the profile page.
  * Invalid sessions are redirected to the application index.
  """
  def oauth2callback(conn, params) do
    case Devise.oauth2_signin(conn, params) do
      {:ok, conn} ->
        redirect(conn, to: Fawlty.Router.Helpers.users_path(:profile))
      {:error, conn} ->
        redirect(conn, to: Fawlty.Router.Helpers.root_path(:index))
    end
      |> halt
  end

  @doc """
  Destroys a session for the user and redirects to the application index.
  """
  def logout(conn, _params) do
    Devise.sign_out(conn)
      |> redirect(to: Fawlty.Router.Helpers.pages_path(:index))
  end

  @doc """

  """
  def authenticated?(conn) do
    case Devise.authenticated?(conn) do
      {:error, conn} ->
        redirect(conn, to: Fawlty.Router.Helpers.pages_path(:index))
          |> halt
      {:ok, conn}    -> conn
    end
  end
end
