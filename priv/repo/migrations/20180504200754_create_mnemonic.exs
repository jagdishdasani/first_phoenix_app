defmodule DataMonitor.Repo.Migrations.CreateMnemonic do
  use Ecto.Migration

  def change do
    create table(:mnemonics) do
      add :mnemonic, :string
      add :unit, :string

      timestamps()
    end
  end
end
