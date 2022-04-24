defmodule LinklistWeb.LinkLive.Index do
  use LinklistWeb, :live_view

  alias Linklist.LinksView
  alias Linklist.LinksView.Link

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :links, list_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Link")
    |> assign(:link, LinksView.get_link!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Link")
    |> assign(:link, %Link{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Links")
    |> assign(:link, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    link = LinksView.get_link!(id)
    {:ok, _} = LinksView.delete_link(link)

    {:noreply, assign(socket, :links, list_links())}
  end

  defp list_links do
    LinksView.list_links()
  end
end
