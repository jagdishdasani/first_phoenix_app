defmodule DataMonitor.ProcessRuleSet do
  use DataMonitor.Web, :controller
  require Logger

  alias DataMonitor.{
    Rule,
    CompanyMetadata,
    RuleEngine,
    Result
  }

  def process_rules(rule_set, company_id, auth_headers) do
    results =
      {:ok, rule_set}
      |> CompanyMetadata.get_metadata(company_id, auth_headers)

    # If core-engine returns data 
    if length(results) > 0 do
      mnemonic_rules = Repo.all(from(r in Rule, where: r.mnemonic in ^rule_set.mnemonics))

      rules_result = RuleEngine.evaluate(results, mnemonic_rules)

      # After appliying rules if found any records, then will crete CSV file and send as 
      # attahment in email
      if length(rules_result) > 0 do
        # file = File.open!("files/#{Timex.today()}_" <> "#{company_id}.csv", [:write, :utf8])
        insert_map =
          Enum.reduce(rules_result, [], fn struct, result ->
            result ++
              [
                Map.from_struct(struct)
                |> Map.put(:inserted_at, Timex.now())
                |> Map.put(:updated_at, Timex.now())
              ]
          end)

        Repo.insert_all(Result, insert_map)

        # RuleResult.csv_content(rules_result) |> Enum.each(&IO.write(file, &1))
        # Email.report_email("files/#{Timex.today()}_" <> "#{company_id}.csv") |> Mailer.deliver()
      end
    end
  end
end
