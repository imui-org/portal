defmodule PortalWeb.InstrumentLive.Index do
  use PortalWeb, :live_view

  alias Portal.Inventory
  alias Portal.Inventory.Instrument

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :instruments, list_instruments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Instrument")
    |> assign(:instrument, Inventory.get_instrument!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Instrument")
    |> assign(:instrument, %Instrument{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Instruments")
    |> assign(:instrument, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    instrument = Inventory.get_instrument!(id)
    {:ok, _} = Inventory.delete_instrument(instrument)

    {:noreply, assign(socket, :instruments, list_instruments())}
  end

  defp list_instruments do
    Inventory.list_instruments()
  end
end
