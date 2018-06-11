defmodule DataMonitor.RuleSet do
  use DataMonitor.Web, :model

  schema "rule_sets" do
    belongs_to(:classification, DataMonitor.Classification)
    field(:mnemonics, {:array, :string}, default: [])
    field(:frequency, :string)
    field(:start_year, :string)
    field(:end_year, :string)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :classification_id,
      :mnemonics,
      :frequency,
      :start_year,
      :end_year
    ])
    |> validate_required([:classification_id, :mnemonics, :frequency, :start_year, :end_year])
  end
end
