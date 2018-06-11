defmodule DataMonitor.Classification do
  use DataMonitor.Web, :model

  schema "classifications" do
    field(:code, :integer)
    field(:name, :string)
    field(:classification_type, :string)
    field(:parent_id, :integer)
    has_many(:rule_sets, DataMonitor.RuleSet)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name, :classification_type, :parent_id])
    |> validate_required([:code, :name, :classification_type, :parent_id])
  end
end
