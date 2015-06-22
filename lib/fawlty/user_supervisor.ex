defmodule Fawlty.UserSupervisor do

  @moduledoc """
  top level supervisor for the pvp application
  """
  use Supervisor

  def start_link do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [])
  end

  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      worker(Fawlty.UserHandler, [], [restart: :temporary, shutdown: :brutal_kill])
    ]

    # for other strategies and supported options
    supervise(children, strategy: :simple_one_for_one)
  end

  def handler() do
    :supervisor.start_child(__MODULE__, [])
  end
end
