defmodule DataMonitor.RuleResult do
  # @derive [Poison.Encoder]

  require Logger

  defstruct [
    :uid,
    :company_name,
    :period,
    :mnemonic,
    :value,
    :is_zero,
    :is_blank,
    :is_negative,
    :unmatched_min_val,
    :min_val,
    :unmatched_max_val,
    :max_val
  ]

  def invalid?(rule_result) do
    if rule_result.is_zero || rule_result.is_blank || rule_result.is_negative ||
         rule_result.unmatched_min_val || rule_result.unmatched_max_val do
      true
    else
      false
    end
  end

  def csv_content(rules_result) do
    csv_header = [
      "Company UID",
      "Company Name",
      "Period",
      "Mnemonic",
      "Value",
      "Is Zero",
      "Is Blank",
      "Is Negative",
      "Min Value Not Matched",
      "Min Value",
      "Max Value Not Matched",
      "Max Value"
    ]

    Enum.reduce(rules_result, [csv_header], fn data_row, result ->
      transformed_row = [
        data_row.uid,
        data_row.name,
        data_row.period,
        data_row.mnemonic,
        data_row.value,
        data_row.is_zero,
        data_row.is_blank,
        data_row.is_negative,
        data_row.unmatched_min_val,
        data_row.min_val,
        data_row.unmatched_max_val,
        data_row.max_val
      ]

      result ++ [transformed_row]
    end)
    |> CSV.encode()
    |> Enum.to_list()
  end
end
