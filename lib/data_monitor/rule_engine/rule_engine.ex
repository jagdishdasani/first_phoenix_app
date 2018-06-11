defmodule DataMonitor.RuleEngine do
  alias DataMonitor.RuleResult
  require Logger

  def evaluate(data_set, rule_set) do
    # Loop to iterate data_set got it from Core-engine
    Enum.reduce(data_set, [], fn data_row, result ->
      result ++ apply_rules(rule_set, data_row)
    end)
  end

  def apply_rules(rule_set, data_row) do
    # Loop to iterate rule_set mnemonics wise from rules table
    rule = Enum.find(rule_set, fn x -> x.mnemonic == data_row.mnemonic end)

    applied = apply_rule(rule, data_row)

    if RuleResult.invalid?(applied) do
      [applied]
    else
      []
    end
  end

  def apply_rule(rule, data_row) do
    %RuleResult{
      uid: data_row.uid,
      company_name: data_row.name,
      period:
        if(
          is_integer(data_row.period),
          do: data_row.period,
          else: String.to_integer(data_row.period)
        ),
      mnemonic: data_row.mnemonic,
      value: data_row.value
    }
    |> validate_zero(rule, data_row)
    |> validate_blank(rule, data_row)
    |> validate_negative(rule, data_row)
    |> validate_min(rule, data_row)
    |> validate_max(rule, data_row)
  end

  defp validate_zero(rule_result, rule, data_row) do
    if !rule.can_zero && data_row.value == 0,
      do: %{rule_result | is_zero: true},
      else: rule_result
  end

  defp validate_blank(rule_result, rule, data_row) do
    if !rule.can_blank && (data_row.value == "" || data_row.value == nil),
      do: %{rule_result | is_blank: true},
      else: rule_result
  end

  defp validate_negative(rule_result, rule, data_row) do
    if !rule.can_negative && data_row.value < 0,
      do: %{rule_result | is_negative: true},
      else: rule_result
  end

  defp validate_min(rule_result, rule, data_row) do
    if (rule.min_val != nil && data_row.value != "" && data_row.value != nil &&
          data_row.value < rule.min_val) ||
         ((rule.unit == 'Ratio' || rule.unit == 'In Percent') &&
            data_row.value * 100 < rule.min_val),
       do: %{
         rule_result
         | unmatched_min_val: true,
           min_val: rule.min_val,
           value:
             if(
               rule.unit == 'Ratio' || rule.unit == 'In Percent',
               do: Float.round(data_row.value * 100, 2),
               else: Float.round(data_row.value, 2)
             )
       },
       else: rule_result
  end

  defp validate_max(rule_result, rule, data_row) do
    if (rule.max_val != nil && data_row.value != "" && data_row.value != nil &&
          data_row.value > rule.max_val) ||
         ((rule.unit == 'Ratio' || rule.unit == 'In Percent') &&
            data_row.value * 100 > rule.max_val),
       do: %{
         rule_result
         | unmatched_max_val: true,
           max_val: rule.max_val,
           value:
             if(
               rule.unit == 'Ratio' || rule.unit == 'In Percent',
               do: Float.round(data_row.value * 100, 2),
               else: Float.round(data_row.value, 2)
             )
       },
       else: rule_result
  end
end
