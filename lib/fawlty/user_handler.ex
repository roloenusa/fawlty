defmodule Fawlty.UserHandler do
  require Record
  require Logger

  @moduledoc """
  A genserver to schedule a player into a pvp pool once the shield runs out. The process maintains on a node per node
  basis a list of available members to the pool, and collects all users into sets by time. The server then schedules itself
  to run at set intervals via `send_after/3`
  """
  use GenServer

  Record.defrecordp :worker_state, [
                                     oauth: nil,
                                     user: nil
                                   ]

  def start() do
    :gen_server.start(__MODULE__, [], [])
  end

  @doc """
  Starts a dispatcher linked to the calling process application supervisor
  """
  # @spec start_link(term) :: {:ok, pid}
  def start_link(args) do
    :gen_server.start_link(__MODULE__, args, [])
  end

  #####
  # Interface
  #####

  def get_state(pid) do
    :gen_server.call(pid, :get_state)
  end

  def authenticated?(pid) do
    :gen_server.call(pid, :check_token)
  end

  def sign_in(pid, code) do
    :gen_server.call(pid, {:sign_in, code})
  end

  def logout(pid) do
    :gen_server.cast(pid, :logout)
  end

  def get_user(pid) do
    :gen_server.call(pid, :get_user)
  end

  #####
  # GenServer Implementation
  #####

  def init({code}) do
    Fawlty.Oauth2Lib.get_oauth_token(code)
    |> do_sign_in(worker_state)
  end

  def handle_call(:get_state, _from, worker_state) do
    {:reply, worker_state, worker_state}
  end

  def handle_call(:check_token, _from, worker_state(oauth: nil) = worker_state) do
    {:reply, {:error, :no_user_found}, worker_state}
  end
  def handle_call(:check_token, _from, worker_state(oauth: token) = worker_state ) do
    response = Fawlty.Oauth2Lib.check_valid_token(token)
    {:reply, response, worker_state}
  end

  def handle_call({:sign_in, code}, _from, worker_state ) do
    {res, worker_state} = Fawlty.Oauth2Lib.get_oauth_token(code)
      |> do_sign_in(worker_state)

    {:reply, res, worker_state}
  end

  def handle_call(:get_user, _from, worker_state(user: user) = worker_state ) do
    {:reply, user, worker_state}
  end

  def handle_Cast(:logout, worker_state ) do
    {:stop, :logout, worker_state}
  end

  ####
  # Private Helpers
  ####

  ####
  # Initialization

  defp handle_init(email, token) do
    user = Fawlty.User.find_by_email(email)
    worker_state(user: user, oauth: token)
  end

  defp do_sign_in({:ok, token, body}, worker_state) do
    %{"email" => email, "name" => name} = body
    user = Fawlty.User.find_by_email(email)
    worker_state = worker_state(worker_state, oauth: token, user: user)
    {:ok, worker_state}
  end
  defp do_sign_in({:error, _}, worker_state) do
    {:stop, :invalid}
  end
end
