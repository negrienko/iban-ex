defmodule IbanEx.Parser do
  @moduledoc false

  alias IbanEx.{Country, Iban, Validator}
  import IbanEx.Commons, only: [normalize_and_slice: 2, blank: 1]

  @type iban_string() :: String.t()
  @type country_code_string() :: <<_::16>>
  @type check_digits_string() :: <<_::16>>

  @type iban() :: IbanEx.Iban.t()
  @type iban_or_error() ::
          {:ok, iban()}
          | {:invalid_checksum, binary()}
          | {:invalid_format, binary()}
          | {:invalid_length, binary()}
          | {:can_not_parse_map, binary()}
          | {:unsupported_country_code, binary()}

  @spec parse({:ok, binary()}) :: iban_or_error()
  def parse({:ok, iban_string}), do: parse(iban_string)

  @spec parse(binary()) :: iban_or_error()
  def parse(iban_string) do
    case Validator.validate(iban_string) do
      {:ok, valid_iban} ->
        iban_map = %{
          country_code: country_code(valid_iban),
          check_digits: check_digits(valid_iban)
        }

        bban_map =
          iban_string
          |> bban()
          |> parse_bban(iban_map.country_code)

        {:ok, struct(Iban, Map.merge(iban_map, bban_map))}

      {:error, error_type} ->
        {:error, error_type}
    end
  end

  @spec parse_bban(binary(), <<_::16>>) :: map()
  def parse_bban(bban_string, country_code, options \\ [incomplete: false])

  def parse_bban(bban_string, country_code, incomplete: true) do
    Country.country_module(country_code).incomplete_rule()
    |> parse_bban_by_regex(bban_string)
  end

  def parse_bban(bban_string, country_code, _options) do
    Country.country_module(country_code).rule()
    |> parse_bban_by_regex(bban_string)
  end

  defp parse_bban_by_regex(_regex, nil), do: %{}
  defp parse_bban_by_regex(regex, bban_string) do
    case Regex.named_captures(regex, bban_string) do
      map when is_map(map) ->
        for {key, val} <- map,
            into: %{},
            do: {String.to_atom(key), blank(val)}

      nil ->
        %{}
    end
  end

  @spec country_code(iban_string()) :: country_code_string()
  def country_code(iban_string), do: normalize_and_slice(iban_string, 0..1) |> blank()

  @spec check_digits(binary()) :: check_digits_string()
  def check_digits(iban_string), do: normalize_and_slice(iban_string, 2..3) |> blank()

  @spec bban(binary()) :: binary()
  def bban(iban_string), do: normalize_and_slice(iban_string, 4..-1//1) |> blank()
end
