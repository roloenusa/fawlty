defmodule Fawlty.SessionsController do
  use Phoenix.Controller

  plug :action

  @moduledoc """
  Controller for session validation, creation and destruction.
  """

  @type conn   :: %Plug.Conn{}

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
    case Oauth2Lib.get_oauth_token(conn, params) do
      {:ok, conn} ->
        redirect(conn, to: Fawlty.Router.Helpers.users_path(:index))
      {:error, conn} ->
        redirect(conn, to: Fawlty.Router.Helpers.root_path(:index))
    end
      |> halt
  end

  @doc """
  Destroys a session for the user and redirects to the application index.
  """
  def logout(conn, _params) do
    Oauth2Lib.sign_out(conn)
    |> redirect(to: Fawlty.Router.Helpers.pages_path(:index))
  end

  ###
  # Helper Functions and Filters

  @doc """
  Checks if with the Oauth2Lib to make sure a session is valid based on a passed list of actions.
  * If the action is in the list but there is no valid session, then it redirects to the login page.
  * If the action is in the list and there is a valid session, then it lets the connection through.
  * If the action is not in the list, it lets the connection through.
  """
  @spec check_session(conn, atom, list(atom)) :: conn
  def check_session(conn, action, auth_actions) do
    case action in auth_actions do
      true -> do_auth(conn)
      _    -> conn
    end
  end

  @spec do_auth(conn) :: conn
  defp do_auth(conn) do
    case Oauth2Lib.authenticate(conn) do
      {:error, conn} -> redirect(conn, to: Fawlty.Router.Helpers.pages_path(:index)) |> halt
      {:ok, conn}    -> conn
    end
  end
end
