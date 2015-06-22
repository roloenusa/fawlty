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
                                   ]

  def start() do
    :gen_server.start(__MODULE__, [], [])
  end

  @doc """
  Starts a dispatcher linked to the calling process application supervisor
  """
  @spec start_link() :: {:ok, pid}
  def start_link() do
    IO.puts "startlink"
    :gen_server.start_link(__MODULE__, [], [])
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

  def init(_args) do
    worker_state = handle_init
    {:ok, worker_state}
  end

  def handle_call(:get_state, _from, worker_state) do
    {:reply, :get_state, worker_state}
  end

  ####
  # Private Helpers
  ####

  ####
  # Initialization

  defp handle_init do
    worker_state(oauth: :all)
  end
end
