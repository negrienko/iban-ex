defmodule IbanEx.Formatter do
  @moduledoc false

  alias IbanEx.Country
  import IbanEx.Commons, only: [normalize: 1]

  @available_formats [:compact, :pretty, :splitted]

  @type iban() :: IbanEx.Iban.t()
  @type available_format() :: :compact | :pretty | :splitted
  @type available_formats_list() :: [:compact | :pretty | :splitted]

  @spec available_formats() :: available_formats_list()
  def available_formats(), do: @available_formats

  @spec pretty(IbanEx.Iban.t()) :: binary()
  def pretty(iban), do: format(iban, :pretty)

  @spec compact(IbanEx.Iban.t()) :: binary()
  def compact(iban), do: format(iban, :compact)

  @spec splitted(IbanEx.Iban.t()) :: binary()
  def splitted(iban), do: format(iban, :splitted)

  @spec format(iban()) :: String.t()
  @spec format(iban(), available_format()) :: String.t()
  def format(iban, format \\ :compact)

  def format(iban, :compact),
    do: format(iban, :pretty) |> normalize()

  def format(iban, :pretty) do
    country_module = Country.country_module(iban.country_code)
    country_module.to_string(iban)
  end

  def format(iban, :splitted) do
    compact = format(iban, :compact)

    ~r/.{1,4}/
    |> Regex.scan(compact)
    |> List.flatten()
    |> Enum.join(" ")
  end
end
