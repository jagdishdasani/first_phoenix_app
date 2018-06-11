defmodule DataMonitor.ProcessManager do
  use GenServer
  require Logger

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def add(pid, process) do
    GenServer.cast(pid, process)
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  # Server
  def init(list) do
    {:ok, list}
  end

  def handle_cast(process, list) do
    updated_list = [process | list]
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    {:reply, list, list}
  end
end
