defmodule Fawlty.Oauth2Lib do

  @moduledoc """
  Wrapper for the OAuth2Ex library to authenticate against services such as Google. This library
  provides methods to sign in and sign out via session creation and deletion and token renewal.
  """

  alias Plug.Conn
  alias Fawlty.Devise

  @typedoc """
  A tuple returned by google with the following information about the account:

  * `"email"`    - the email associated with the account
  * `"name"`        - the full name associated with the account
  * `"picture"`     - the url for the google profile image.
  """
  @type info            :: map

  @type conn            :: %Plug.Conn{}
  @type token           :: %OAuth2Ex.Token{}
  @type oauth2ex_config :: %OAuth2Ex.Config{}

  @session_key :oauth2_token
  @user_info_key :oauth2_user_info

  ####
  # Authentication

  @doc """
  Verify the user has access to the server based on their token information
  """
  @spec get_oauth_token(conn, info) :: {:ok, conn} | {:error, conn}
  def get_oauth_token(conn, %{"code" => code}) do

    try do
      token = OAuth2Ex.get_token(config, code)
      response = OAuth2Ex.HTTP.get(token, google_url(:email_url))
      check_user_info(response.body)
      |> validate_session(conn, token, response.body)
    rescue
      OAuth2Ex.Error -> {:error, conn}
    end
  end

  @spec check_user_info(info) :: boolean
  defp check_user_info(%{"email" => email}) do
    Regex.match?(~r/@/, email)
  end

  @spec validate_session(boolean, conn, token, info) :: {:ok | :error, conn}
  defp validate_session(false, conn, _token, _info), do: {:error, conn}
  defp validate_session(true, conn, token, info) do
    {:ok, save_session(conn, token, info)}
  end

  ####
  # Sign out

  @doc """
  Delete the session information from a connection
  """
  @spec sign_out(conn) :: conn
  def sign_out(conn) do
    conn
    |> Conn.delete_session(@user_info_key)
    |> Conn.delete_session(@session_key)
  end

  ####
  # Session information

  @doc """
  Retrieve all the user information stored for the session.
  """
  @spec get_user_info(conn) :: conn
  def get_user_info(conn) do
    Conn.get_session(conn, @user_info_key)
  end

  ####
  # Authentication

  @doc """
  Execute any authentication on the user connection.
  """
  @spec authenticate(conn) :: {:ok | :error, conn}
  def authenticate(conn) do
    check_session(conn)
  end

  @spec check_session(conn) :: {:ok | :error, conn}
  defp check_session(conn) do
    case Conn.get_session(conn, @session_key) do
      nil   -> {:error, conn}
      token -> check_valid_token(conn, token)
    end
  end

  @spec save_session(conn, token, info) :: conn
  defp save_session(conn, token, info) do
    user = Devise.init_session(info, token)

    conn
    |> Conn.put_session(@session_key, token)
    |> Conn.put_session(@user_info_key, info)
  end

  @spec check_valid_token(conn, token) :: {:ok | :error, conn}
  defp check_valid_token(conn, token) do
    try do
      token = OAuth2Ex.ensure_token(config, token)
      info = get_user_info(conn)
      conn = save_session(conn, token, info)
      {:ok, conn}
    rescue
      OAuth2Ex.Error -> {:error, conn}
    end
  end

  ####
  # Configurations

  @doc """
  Gets the google url for authentication
  """
  @spec authorized_url :: bitstring
  def authorized_url do
    config
    |> OAuth2Ex.get_authorize_url
  end

  @spec config :: oauth2ex_config
  defp config do
    {:ok, oauth2_configs} = :application.get_env(:fawlty, :oauth2ex)
    OAuth2Ex.config(oauth2_configs)
  end

  @spec google_url(atom) :: bitstring | nil
  defp google_url(type) do
    {:ok, urls} = :application.get_env(:fawlty, :google)
    Dict.fetch!(urls, type)
  end
end
