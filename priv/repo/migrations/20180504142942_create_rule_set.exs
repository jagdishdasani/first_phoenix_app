defmodule DataMonitor.Repo.Migrations.CreateRuleSet do
  use Ecto.Migration

  def change do
    create table(:rule_sets) do
      add(:classification_id, references(:classifications))
      add(:mnemonics, {:array, :string}, default: [])
      add(:frequency, :string)
      add(:start_year, :string)
      add(:end_year, :string)

      timestamps()
    end
  end
end
