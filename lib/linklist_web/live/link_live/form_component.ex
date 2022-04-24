defmodule LinklistWeb.LinkLive.FormComponent do
  use LinklistWeb, :live_component

  alias Linklist.LinksView

  @impl true
  def update(%{link: link} = assigns, socket) do
    changeset = LinksView.change_link(link)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  @spec handle_event(
          <<_::32, _::_*32>>,
          map,
          atom | %{:assigns => atom | map, optional(any) => any}
        ) :: {:noreply, any}
  def handle_event("validate", %{"link" => link_params}, socket) do
    changeset =
      socket.assigns.link
      |> LinksView.change_link(link_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"link" => link_params}, socket) do
    save_link(socket, socket.assigns.action, link_params)
  end

  defp save_link(socket, :edit, link_params) do
    case LinksView.update_link(socket.assigns.link, link_params) do
      {:ok, _link} ->
        {:noreply,
         socket
         |> put_flash(:info, "Link updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_link(socket, :new, link_params) do
    case LinksView.create_link(link_params) do
      {:ok, _link} ->
        {:noreply,
         socket
         |> put_flash(:info, "Link created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
