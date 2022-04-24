defmodule Linklist.LinksViewTest do
  use Linklist.DataCase

  alias Linklist.LinksView

  describe "links" do
    alias Linklist.LinksView.Link

    import Linklist.LinksViewFixtures

    @invalid_attrs %{description: nil, image_url: nil, title: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert LinksView.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert LinksView.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{description: "some description", image_url: "some image_url", title: "some title", url: "some url"}

      assert {:ok, %Link{} = link} = LinksView.create_link(valid_attrs)
      assert link.description == "some description"
      assert link.image_url == "some image_url"
      assert link.title == "some title"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LinksView.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{description: "some updated description", image_url: "some updated image_url", title: "some updated title", url: "some updated url"}

      assert {:ok, %Link{} = link} = LinksView.update_link(link, update_attrs)
      assert link.description == "some updated description"
      assert link.image_url == "some updated image_url"
      assert link.title == "some updated title"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = LinksView.update_link(link, @invalid_attrs)
      assert link == LinksView.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = LinksView.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> LinksView.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = LinksView.change_link(link)
    end
  end
end
