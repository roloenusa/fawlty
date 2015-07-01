defmodule Fawlty.Devise do

  @moduledoc """

  """

  defstruct id: nil, token: nil, provider: nil, pid: nil

  alias Plug.Conn
  alias Fawlty.User
  alias Fawlty.Oauth2Lib

  @session_key :devise_session

  @doc """
  Log on using an oauth2 connection.
  """
  def oauth2_signin(conn, %{"code" => code} = params) do
    Fawlty.UserSupervisor.get_user(code)
      |> handle_oauth2_signin(conn)
  end

  @doc """
  Remove the session for the user.
  """
  def sign_out(conn) do
    get_session(conn)
      |> Fawlty.UserHandler.logout
    Conn.delete_session(conn, @session_key)
  end

  @doc """
  Get the session user.
  """
  def get_session(conn) do
    pid = Conn.get_session(conn, @session_key)
    case is_pid(pid) and :erlang.is_process_alive(pid) do
      true -> pid
         _ -> nil
    end
  end

  defp get_or_create_user(%User{email: email} = user) do
    case User.find_by_email(email) do
      nil  -> User.create(user)
      user -> user
    end
  end

  defp handle_oauth2_signin({:error, _}, conn), do: {:error, conn}
  defp handle_oauth2_signin({:ok, pid}, conn) do
    conn = create_session(conn, pid)
    {:ok, conn}
  end

  defp create_session(conn, pid) do
    Conn.put_session(conn, @session_key, pid)
  end

  defp do_check_session(conn, pid) when is_pid(pid) do
    case Fawlty.UserHandler.authenticated?(pid) do
      {:ok, _} -> {:ok, conn}
      {:error, _} -> {:ok, conn}
    end
  end
  defp do_check_session(conn, _), do: {:error, conn}

  ####
  # Authentication

  @doc """
  Check the session. Verify the user is authenticated.
  """
  def authenticated?(conn) do
    pid = get_session(conn)
    do_check_session(conn, pid)
  end

  def signed_user(conn) do
    pid = get_session(conn)
    Fawlty.UserHandler.get_user(pid)
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
