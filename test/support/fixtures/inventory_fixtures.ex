defmodule Portal.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portal.Inventory` context.
  """

  @doc """
  Generate a instrument.
  """
  def instrument_fixture(attrs \\ %{}) do
    {:ok, instrument} =
      attrs
      |> Enum.into(%{
        available: true,
        description: "some description",
        name: "some name"
      })
      |> Portal.Inventory.create_instrument()

    instrument
  end
end
