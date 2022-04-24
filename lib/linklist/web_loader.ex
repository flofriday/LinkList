defmodule Linklist.WebLoader do
  def load_attrs(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Floki.parse_document(body) do
          {:ok, doc} -> attach_metadata(url, doc)
          _ -> %{url: url} |> attach_title_default(url)
        end

      {:error, %HTTPoison.Error{reason: _reason}} ->
        %{url: url} |> attach_title_default(url)
    end
  end

  defp attach_metadata(url, doc) do
    # The order here is firstcome first set.
    # That means if a function earlier in the pipline sets a field later
    # functions won't override them

    %{url: url}
    |> attach_field(doc, :title, "title")
    |> attach_field_meta(doc, :title, "meta[property='og:title']")
    |> attach_field_meta(doc, :title, "meta[name='twitter:title']")
    |> attach_field_meta(doc, :description, "meta[property='og:description']")
    |> attach_field_meta(doc, :description, "meta[name='twitter:description']")
    |> attach_field_meta(doc, :image_url, "meta[property='og:image']")
    |> attach_field_meta(doc, :image_url, "meta[name='twitter:image']")
    |> attach_title_default(url)
  end

  defp attach_field(link, doc, field, selector) do
    if Map.get(link, field) == nil do
      # Not yet set so lets do this
      case Floki.find(doc, selector) do
        [first | _others] ->
          Map.put(link, field, Floki.text(first))

        [] ->
          link
      end
    else
      # Already set
      link
    end
  end

  # I don't know why meta tags have their content in an attribute but not
  # in the actual body. But here we go handeling that extra case.
  defp attach_field_meta(link, doc, field, selector) do
    if Map.get(link, field) == nil do
      # Not yet set so lets do this
      case Floki.find(doc, selector) do
        [first | _others] ->
          case Floki.attribute(first, "content") do
            [head | _tail] ->
              Map.put(link, field, head)

            [] ->
              link
          end

        [] ->
          link
      end
    else
      # Already set
      link
    end
  end

  defp attach_title_default(%{:title => nil} = link, url) do
    # Personally I think that the default title should be the url without the
    # scheme as the scheme is kinda obvious.
    uri = URI.parse(url)
    title = String.slice(URI.to_string(%URI{uri | scheme: nil}), 2..-1)
    Map.put(link, :title, title)
  end

  defp attach_title_default(link, _title) do
    link
  end
end
