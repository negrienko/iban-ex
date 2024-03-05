defmodule IbanEx.Parser do
  alias IbanEx.{Country, Iban, Validator}
  import IbanEx.Commons, only: [normalize_and_slice: 2]

  @type iban_string() :: String.t()
  @type country_code_string() :: <<_::16>>
  @type check_digits_string() :: <<_::16>>
  @type iban_or_error() :: IbanEx.Iban.t() | {:error, atom()}

  @spec parse({:ok, String.t()} | String.t()) :: iban_or_error()
  def parse({:ok, iban_string}), do: parse(iban_string)
  def parse(iban_string) do
    with {:ok, valid_iban} <- Validator.validate(iban_string) do
      iban_map = %{
        country_code: country_code(valid_iban),
        check_digits: check_digits(valid_iban),
      }

      regex = Country.country_module(iban_map.country_code).rule()
      bban = bban(iban_string)
      bban_map = for {key, val} <- Regex.named_captures(regex, bban), into: %{}, do: {String.to_atom(key), val}

      {:ok, struct(Iban, Map.merge(iban_map, bban_map))}
    else
      {:error, error_type} -> {:error, error_type}
    end
  end

  @spec country_code(iban_string()) :: country_code_string()
  def country_code(iban_string), do: normalize_and_slice(iban_string, 0..1)

  @spec check_digits(binary()) :: check_digits_string()
  def check_digits(iban_string), do: normalize_and_slice(iban_string, 2..3)

  @spec bban(binary()) :: binary()
  def bban(iban_string), do: normalize_and_slice(iban_string, 4..-1//1)
end
