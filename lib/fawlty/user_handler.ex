defmodule Fawlty.UserHandler do
  require Record

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

  @doc """
  Add a player to the pvp_pool job_list
  """
  @spec get_state(pid) :: :ok
  def get_state(pid) do
    :gen_server.call(pid, :get_state)
  end

  #####
  # GenServer Implementation
  #####

  def init({email, token}) do
    worker_state = handle_init(email, token)
    {:ok, worker_state}
  end

  def handle_call(:get_state, _from, worker_state) do
    {:reply, worker_state, worker_state}
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
end
