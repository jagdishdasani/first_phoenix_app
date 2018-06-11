defmodule DataMonitor.Result do
  use DataMonitor.Web, :model

  schema "results" do
    field(:uid, :integer)
    field(:company_name, :string)
    field(:period, :integer)
    field(:mnemonic, :string)
    field(:value, :float)
    field(:is_zero, :boolean)
    field(:is_blank, :boolean)
    field(:is_negative, :boolean)
    field(:unmatched_min_val, :boolean)
    field(:min_val, :float)
    field(:unmatched_max_val, :boolean)
    field(:max_val, :float)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
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
    ])
    |> validate_required([
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
    ])
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
        data_row.company_name,
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
