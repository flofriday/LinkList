defmodule Linklist.LinksView.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :description, :string
    field :image_url, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:description, :image_url, :title, :url])
    |> validate_required([:url])
  end
end
