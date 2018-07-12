defmodule Mix.Tasks.Mon do
  use Mix.Task
  use ImportMonitor

  @shortdoc "Simply runs the import on BMW from Avito"
  def run(_) do
    category_links = Avito.fetch("/rossiya/avtomobili/bmw") |> Avito.parse_categories
    #[link|_] = category_links
    category_links |> Enum.each(fn(link) ->
      link |> Avito.parse_models |> Avito.save(link, "./share/yaml")
      :timer.sleep(1000)
    end)
  end
end
