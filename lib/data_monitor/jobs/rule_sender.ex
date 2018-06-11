defmodule DataMonitor.RuleSender do
  use DataMonitor.Web, :controller

  alias DataMonitor.{
    RuleSet,
    Company,
    RuleReceiver,
    ProcessManager
  }

  @no_of_reuest_per_process 100

  require Logger

  def auth_headers, do: Application.get_env(:data_monitor, DataMonitor.Endpoint)[:auth_headers]

  def perform() do
    rule_sets =
      Repo.all(RuleSet)
      |> Repo.preload(:classification)

    {:ok, pid} = RuleReceiver.start_link()
    {:ok, process_manager_id} = ProcessManager.start_link()
    ProcessManager.add(process_manager_id, {:ok, pid})

    Enum.each(rule_sets, fn rule_set ->
      companies =
        Repo.all(
          from(
            c in Company,
            select: c.uid,
            where: c.level_three_id == ^rule_set.classification.code,
            where: c.is_active == true
          )
        )

      companies
      |> Enum.with_index()
      |> Enum.each(fn {company_id, i} ->
        {:ok, pid} = get_pid(i, process_manager_id)

        RuleReceiver.process_rules(pid, {rule_set, company_id, auth_headers()})
      end)
    end)
  end

  def perform(rule_set) do
    {:ok, pid} = RuleReceiver.start_link()
    {:ok, process_manager_id} = ProcessManager.start_link()
    ProcessManager.add(process_manager_id, {:ok, pid})

    companies =
      Repo.all(
        from(
          c in Company,
          select: c.uid,
          where: c.level_three_id == ^rule_set.classification.code,
          where: c.is_active == true
        )
      )

    companies
    |> Enum.with_index()
    |> Enum.each(fn {company_id, i} ->
      {:ok, pid} = get_pid(i, process_manager_id)

      RuleReceiver.process_rules(pid, {rule_set, company_id, auth_headers()})
    end)
  end

  def get_pid(i, process_manager_id) do
    if i == @no_of_reuest_per_process * div(i, @no_of_reuest_per_process) + 1 do
      Logger.info("No of Processes created := #{div(i, @no_of_reuest_per_process)}")

      # Create a new RuleReciver process and store it in manager
      {:ok, pid} = RuleReceiver.start_link()
      ProcessManager.add(process_manager_id, {:ok, pid})
    end

    # Read First RuleReciver Id from array of processes of manager in case of not multiple of @no_of_reuest_per_process
    hd(ProcessManager.view(process_manager_id))
  end
end
