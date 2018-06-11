defmodule DataMonitor.Repo.Migrations.CreateRule do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add(:mnemonic, :string)
      add(:description, :text)
      add(:unit, :text)
      add(:can_zero, :boolean, default: false, null: false)
      add(:can_blank, :boolean, default: false, null: false)
      add(:can_negative, :boolean, default: false, null: false)
      add(:min_val, :float)
      add(:max_val, :float)

      timestamps()
    end
  end
end
