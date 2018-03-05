defmodule Avito do
  require IEx

  @moduledoc """
  Documentation for Avito.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Avito.hello
      :world

  """
  def fetch path do
    full = "https://www.avito.ru" <> path
    #require IEx; IEx.pry
    #b=HTTPotion.get(full, [timeout: 30_000, ibrowse: [proxy_host: '127.0.0.1', proxy_port: 8118]]).body
    b=HTTPotion.get(full).body
    if byte_size(b) == 0, do: IEx.pry
    :timer.sleep(10)
    b |> IO.iodata_to_binary
  end

  def paths_for category do
    count = Integer.floor_div(category[:size] + 49, 50)

    1..count |> Enum.map(fn(i) -> category[:path] <> "?p=#{i}" end)
  end

  def parse_categories html do
    import Meeseeks.CSS
    import Meeseeks
    import Enum, only: [map: 2]
    import List, only: [keyfind: 3]
    import String, only: [replace: 3]

    doc = parse(html)
    brand = doc |> one(css(".breadcrumbs .breadcrumbs-link_large")) |> text

    try do
      doc |> one(css(".catalog-counts__section")) |> all(css("li")) |> map(fn(li) ->
        {"href", href} = one(li, css("a")) |> attrs |> List.keyfind("href", 0)
        {size, ""} = one(li, css(".catalog-counts__number")) |> text |> replace(" ", "") |> Integer.parse

        [path: href, size: size, brand: brand]
      end)
    rescue
      e in FunctionClauseError -> IEx.pry
    end
  end

  def parse_models category do
    import Meeseeks.CSS
    import Meeseeks
    import Regex, only: [named_captures: 2]
    import List, only: [flatten: 1, first: 1]
    import Enum, only: [reduce: 3]
    import String, only: [split: 2, replace: 3]

    #require IEx; IEx.pry
    a_s = paths_for(category) |> reduce([], fn(path, parsed) ->
      try do
        fetch(path) |> parse |> one(css(".catalog-list")) |> all(css(".item")) |> reduce(parsed, fn(item, parsed) ->
          try do
            info = one(item, css(".description h3")) |> text
            [ brand_mark | year_text ] = info |> split(~r/,\s?/)
            #require IEx; IEx.pry unless year_text
            {year, _} = year_text |> first |> String.replace(~r'[^\d]', "") |> Integer.parse
            mark = named_captures(~r/#{category[:brand]} (?<mark>.*)/, brand_mark)["mark"]
            {price, _} = one(item, css(".about")) |> text |> split(["руб. "]) |> first |> replace(" ", "") |> Integer.parse
            [ [brand: category[:brand], mark: mark, year: year, price: price] | parsed ]
          rescue
            e in MatchError -> IEx.pry
          end
        end)
      rescue
        e in FunctionClauseError -> IEx.pry
      end
    end)

    #require IEx; IEx.pry
    a_s
  end

  def save data, url, path do
    #require IEx; IEx.pry
    name = path <> "/" <> String.replace(url[:path], "/", "_") <> ".yaml"
    yaml = RelaxYaml.encode!(data)
    File.write!(name, yaml)

    yaml
  end

  def __using__ _args do
    :ibrowse.start()
  end
end
