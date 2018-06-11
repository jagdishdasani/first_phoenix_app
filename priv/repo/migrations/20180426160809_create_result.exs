defmodule DataMonitor.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :uid, :integer
      add :company_name, :string
      add :period, :integer
      add :mnemonic, :string
      add :value, :float
      add :is_zero, :boolean, default: false, null: false
      add :is_blank, :boolean, default: false, null: false
      add :is_negative, :boolean, default: false, null: false
      add :unmatched_min_val, :boolean, default: false, null: false
      add :min_val, :float
      add :unmatched_max_val, :boolean, default: false, null: false
      add :max_val, :float

      timestamps()
    end
  end
end
