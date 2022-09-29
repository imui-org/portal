defmodule Portal.InventoryTest do
  use Portal.DataCase

  alias Portal.Inventory

  describe "instruments" do
    alias Portal.Inventory.Instrument

    import Portal.InventoryFixtures

    @invalid_attrs %{available: nil, description: nil, name: nil}

    test "list_instruments/0 returns all instruments" do
      instrument = instrument_fixture()
      assert Inventory.list_instruments() == [instrument]
    end

    test "get_instrument!/1 returns the instrument with given id" do
      instrument = instrument_fixture()
      assert Inventory.get_instrument!(instrument.id) == instrument
    end

    test "create_instrument/1 with valid data creates a instrument" do
      valid_attrs = %{available: true, description: "some description", name: "some name"}

      assert {:ok, %Instrument{} = instrument} = Inventory.create_instrument(valid_attrs)
      assert instrument.available == true
      assert instrument.description == "some description"
      assert instrument.name == "some name"
    end

    test "create_instrument/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_instrument(@invalid_attrs)
    end

    test "update_instrument/2 with valid data updates the instrument" do
      instrument = instrument_fixture()
      update_attrs = %{available: false, description: "some updated description", name: "some updated name"}

      assert {:ok, %Instrument{} = instrument} = Inventory.update_instrument(instrument, update_attrs)
      assert instrument.available == false
      assert instrument.description == "some updated description"
      assert instrument.name == "some updated name"
    end

    test "update_instrument/2 with invalid data returns error changeset" do
      instrument = instrument_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_instrument(instrument, @invalid_attrs)
      assert instrument == Inventory.get_instrument!(instrument.id)
    end

    test "delete_instrument/1 deletes the instrument" do
      instrument = instrument_fixture()
      assert {:ok, %Instrument{}} = Inventory.delete_instrument(instrument)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_instrument!(instrument.id) end
    end

    test "change_instrument/1 returns a instrument changeset" do
      instrument = instrument_fixture()
      assert %Ecto.Changeset{} = Inventory.change_instrument(instrument)
    end
  end
end
