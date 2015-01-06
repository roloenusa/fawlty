defmodule Fawlty.Devise do

  @moduledoc """

  """

  defstruct id: nil, token: nil, provider: nil

  alias Plug.Conn
  alias Fawlty.User
  alias Fawlty.Oauth2Lib

  @session_key :devise_session

  @doc """
  Log on using an oauth2 connection.
  """
  def oauth2_signin(conn, params) do
    Oauth2Lib.get_oauth_token(conn, params)
      |> handle_oauth2_signin
  end

  @doc """
  Remove the session for the user.
  """
  def sign_out(conn) do
    conn
      |> Conn.delete_session(@session_key)
  end

  @doc """
  Get the session user.
  """
  def get_session(conn) do
    Conn.get_session(conn, @session_key)
  end

  defp get_or_create_user(%User{email: email} = user) do
    case User.find_by_email(email) do
      nil  -> User.create(user)
      user -> user
    end
  end

  defp handle_oauth2_signin({:error, conn} = error), do: error
  defp handle_oauth2_signin({:ok, conn, token, user_info}) do
    %{"email" => email, "name" => name} = user_info
    user = %Fawlty.User{name: name, email: email, encrypted_password: generate_password}
             |> get_or_create_user

    conn = create_session(conn, user.id, token)
    {:ok, conn}
  end

  defp create_session(conn, id, token) do
    conn
      |> Conn.put_session(@session_key, %Fawlty.Devise{id: id, token: token})
  end


  defp do_check_session(conn, %Fawlty.Devise{id: nil}), do: {:error, conn}
  defp do_check_session(conn, %Fawlty.Devise{id: id, token: nil}), do: {:ok, conn}
  defp do_check_session(conn, %Fawlty.Devise{id: id, token: token}) do
    case Oauth2Lib.check_valid_token(token) do
      {:ok, ^token} ->
        {:ok, conn}
      {:ok, provider} ->
        conn = create_session(conn, id, token)
        {:ok, conn}
      error ->
        {:error, conn}
    end
  end
  defp do_check_session(conn, d), do: {:error, conn}

  ####
  # Authentication

  @doc """
  Check the session. Verify the user is authenticated.
  """
  def authenticated?(conn) do
    session = get_session(conn)
    do_check_session(conn, session)
  end

  def signed_user(conn) do
    %Fawlty.Devise{id: id} = get_session(conn)
    User.get(id)
  end

  ####
  # Encryption

  defp generate_password do
    :crypto.rand_bytes(10)
      |> encrypt_password
  end

  defp encrypt_password(password), do: :erlpass.hash(password)

  defp match_password(password, hash) do
    :erlpass.match(password, hash)
  end
end
