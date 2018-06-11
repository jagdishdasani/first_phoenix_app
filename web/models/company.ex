defmodule DataMonitor.Company do
  use DataMonitor.Web, :model

  schema "companies" do
    field(:name, :string)
    field(:uid, :integer)
    field(:level_one_id, :integer)
    field(:level_two_id, :integer)
    field(:level_three_id, :integer)
    field(:level_four_id, :integer)
    field(:is_active, :boolean)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :id,
      :name,
      :uid,
      :level_one_id,
      :level_two_id,
      :level_three_id,
      :level_four_id,
      :is_active
    ])
  end
end
