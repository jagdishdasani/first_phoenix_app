defmodule DataMonitor.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:name, :string)
      add(:uid, :integer, primary_key: true)
      add(:level_one_id, :integer)
      add(:level_two_id, :integer)
      add(:level_three_id, :integer)
      add(:level_four_id, :integer)
      add(:is_active, :boolean)
    end
  end
end
