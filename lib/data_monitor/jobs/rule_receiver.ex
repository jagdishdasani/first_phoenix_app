defmodule DataMonitor.RuleReceiver do
  use GenServer

  require Logger

  alias DataMonitor.{
    ProcessRuleSet
  }

  def init(state) do
    {:ok, state}
  end

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def process_rules(receiver_pid, {rule_set, company_id, auth_headers}) do
    GenServer.cast(receiver_pid, {rule_set, company_id, auth_headers})
  end

  def handle_cast({rule_set, company_id, auth_headers}, state) do
    ProcessRuleSet.process_rules(rule_set, company_id, auth_headers)

    {:noreply, state}
  end
end
