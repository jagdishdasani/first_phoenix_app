defmodule DataMonitor.Mnemonic do
  use DataMonitor.Web, :model

  schema "mnemonics" do
    field(:mnemonic, :string)
    field(:unit, :string)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:mnemonic, :unit])
    |> validate_required([:mnemonic, :unit])
  end
end
