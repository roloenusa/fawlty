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
  @spec get_oauth_token(info) :: {:ok, token, term} | {:error, :invalid}
  def get_oauth_token(code) do
    try do
      token = OAuth2Ex.get_token(config, code)
      %HTTPoison.Response{body: body} = response = OAuth2Ex.HTTP.get(token, google_url(:email_url))
      {:ok, token, body}
    rescue
      OAuth2Ex.Error -> {:error, :invalid}
    end
  end

  @spec check_valid_token(token) :: {:ok, token} | {:error, atom}
  def check_valid_token(token) do
    try do
      token = OAuth2Ex.ensure_token(config, token)
      {:ok, token}
    rescue
      OAuth2Ex.Error -> {:error, :invalid}
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
