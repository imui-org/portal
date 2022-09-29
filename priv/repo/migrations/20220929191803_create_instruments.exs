defmodule Portal.Repo.Migrations.CreateInstruments do
  use Ecto.Migration

  def change do
    create table(:instruments) do
      add :name, :string
      add :description, :string
      add :available, :boolean, default: false, null: false

      timestamps()
    end
  end
end
