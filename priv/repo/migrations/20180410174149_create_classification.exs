defmodule DataMonitor.Repo.Migrations.CreateClassification do
  use Ecto.Migration

  def change do
    create table(:classifications) do
      add(:code, :integer)
      add(:name, :string)
      add(:classification_type, :string)
      add(:parent_id, :integer)
    end
  end
end
