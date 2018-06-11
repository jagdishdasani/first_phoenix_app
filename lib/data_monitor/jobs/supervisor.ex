defmodule DataMonitor.Supervisor do
  use Supervisor, otp_app: :data_monitor

  alias DataMonitor.RuleReceiver

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec

    children = [
      worker(RuleReceiver, [], restart: :transient)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
