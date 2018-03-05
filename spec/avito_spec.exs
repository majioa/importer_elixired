defmodule AvitoSpec do
  use ESpec
  use ExVCR.Mock

  before_all do
    ExVCR.Config.cassette_library_dir("fixtures/vcr_cassettes")
  end

  let :xml do
    """
    <html>
      <body>
        <p>Text
        </p>
      </body>
    </html>
    """
  end

  let :text do
    # { xml, _rest } = :xmerl_scan.string(bitstring_to_list(xml))
    # texts = :xmerl_xpath.string('/html/body/p/text()', subject)
    texts = subject |> Exmerl.XPath.find("/html/body/p/text()")
    text = texts |> IO.inspect |> Enum.map(fn(x) -> x.value end)
    # subject |> Exmerl.XPath.find("/html/body/p/text()") |> Enum.map(fn(x) -> x.value end)
  end

  describe "html" do

    let :category_links do
      #use_cassette "avito" do
        Avito.fetch("/rossiya/avtomobili/bmw") |> Avito.parse_categories
        #end
    end

    let :model_links do
      #[_|tail] = category_links
      #[e|_] = tail
      [e|_] = category_links
      #use_cassette "avito1" do
        e |> Avito.parse_models
        #end
    end

    let :save do
      model_links |> Avito.save("/rossiya/avtomobili/bmw", ".")
    end

    xcontext "fetch" do
      subject do: Avito.fetch("/rossiya/avtomobili/bmw")

      it do: is_expected |> to_not(be_empty)
      it do: expect subject |> to(be_binary)
    end

    context "parse root" do
      subject do: category_links

      xit do: is_expected |> to_not(be_empty)
      xit do: expect subject |> to(be_list)
      xit do: expect(length(subject)) |> to(eq(36))
      xit do: expect(List.first(subject)) |> to(eq([url: "/rossiya/avtomobili/bmw/1m", size: 2, brand: "BMW"]))
    end

    context "parse category" do
      subject do: model_links

      xit do: is_expected |> to_not(be_empty)
      xit do: expect subject |> to(be_list)
      xit do: expect(length(subject)) |> to(eq(1244))
      xit do: expect(List.first(subject)) |> to(eq([brand: "BMW", mark: "1 серия", year: 2007, price: 420000]))
    end

    context "save" do
      subject do: save

      it do: expect subject |> to(be_binary)
    end

    xcontext "parse model" do
      #subject do: model_data

      it do
        #expect(type_of(subject)).to eq("Map")
        expect(subject.brand).to eq("BMW")
        expect(subject.model).to eq("1M")
        expect(subject.year).to eq("2013")
        expect(subject.price).to eq(1_750_000)
      end
    end

    xcontext "parse" do
      # subject do: fn -> "<html></html>" end
      subject do: Exmerl.from_string(xml)

      xit do: is_expected() |> to(eq("<html></html>"))
      it "www" do
        expect(text).to eq("Text")
      end
    end
  end
end
