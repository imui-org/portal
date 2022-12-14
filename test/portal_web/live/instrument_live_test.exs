defmodule PortalWeb.InstrumentLiveTest do
  use PortalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portal.InventoryFixtures

  @create_attrs %{available: true, description: "some description", name: "some name"}
  @update_attrs %{available: false, description: "some updated description", name: "some updated name"}
  @invalid_attrs %{available: false, description: nil, name: nil}

  defp create_instrument(_) do
    instrument = instrument_fixture()
    %{instrument: instrument}
  end

  describe "Index" do
    setup [:create_instrument]

    test "lists all instruments", %{conn: conn, instrument: instrument} do
      {:ok, _index_live, html} = live(conn, Routes.instrument_index_path(conn, :index))

      assert html =~ "Listing Instruments"
      assert html =~ instrument.description
    end

    test "saves new instrument", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.instrument_index_path(conn, :index))

      assert index_live |> element("a", "New Instrument") |> render_click() =~
               "New Instrument"

      assert_patch(index_live, Routes.instrument_index_path(conn, :new))

      assert index_live
             |> form("#instrument-form", instrument: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instrument-form", instrument: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instrument_index_path(conn, :index))

      assert html =~ "Instrument created successfully"
      assert html =~ "some description"
    end

    test "updates instrument in listing", %{conn: conn, instrument: instrument} do
      {:ok, index_live, _html} = live(conn, Routes.instrument_index_path(conn, :index))

      assert index_live |> element("#instrument-#{instrument.id} a", "Edit") |> render_click() =~
               "Edit Instrument"

      assert_patch(index_live, Routes.instrument_index_path(conn, :edit, instrument))

      assert index_live
             |> form("#instrument-form", instrument: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instrument-form", instrument: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instrument_index_path(conn, :index))

      assert html =~ "Instrument updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes instrument in listing", %{conn: conn, instrument: instrument} do
      {:ok, index_live, _html} = live(conn, Routes.instrument_index_path(conn, :index))

      assert index_live |> element("#instrument-#{instrument.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#instrument-#{instrument.id}")
    end
  end

  describe "Show" do
    setup [:create_instrument]

    test "displays instrument", %{conn: conn, instrument: instrument} do
      {:ok, _show_live, html} = live(conn, Routes.instrument_show_path(conn, :show, instrument))

      assert html =~ "Show Instrument"
      assert html =~ instrument.description
    end

    test "updates instrument within modal", %{conn: conn, instrument: instrument} do
      {:ok, show_live, _html} = live(conn, Routes.instrument_show_path(conn, :show, instrument))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Instrument"

      assert_patch(show_live, Routes.instrument_show_path(conn, :edit, instrument))

      assert show_live
             |> form("#instrument-form", instrument: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#instrument-form", instrument: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instrument_show_path(conn, :show, instrument))

      assert html =~ "Instrument updated successfully"
      assert html =~ "some updated description"
    end
  end
end
