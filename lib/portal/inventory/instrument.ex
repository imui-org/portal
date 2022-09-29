defmodule Portal.Inventory.Instrument do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instruments" do
    field :available, :boolean, default: false
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(instrument, attrs) do
    instrument
    |> cast(attrs, [:name, :description, :available])
    |> validate_required([:name, :description, :available])
  end
end
