defmodule DataMonitor.Rule do
  use DataMonitor.Web, :model

  schema "rules" do
    field(:mnemonic, :string)
    field(:description, :string)
    field(:unit, :string)
    field(:can_zero, :boolean, default: false)
    field(:can_blank, :boolean, default: false)
    field(:can_negative, :boolean, default: false)
    field(:min_val, :float)
    field(:max_val, :float)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :mnemonic,
      :description,
      :unit,
      :can_zero,
      :can_blank,
      :can_negative,
      :min_val,
      :max_val
    ])
    |> validate_required([
      :mnemonic,
      :description,
      :unit,
      :can_zero,
      :can_blank,
      :can_negative
    ])
  end
end
