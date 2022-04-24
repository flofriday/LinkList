defmodule Linklist.LinksViewFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Linklist.LinksView` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image_url: "some image_url",
        title: "some title",
        url: "some url"
      })
      |> Linklist.LinksView.create_link()

    link
  end
end
