defmodule IbanEx.Country do
  @moduledoc false

  import IbanEx.Commons, only: [normalize: 1]

  @type country_code() :: <<_::16>> | atom()
  @type error_tuple() :: {:error, atom()}

  @supported_countries %{
    "AT" => IbanEx.Country.AT,
    "BE" => IbanEx.Country.BE,
    "BG" => IbanEx.Country.BG,
    "CH" => IbanEx.Country.CH,
    "CY" => IbanEx.Country.CY,
    "CZ" => IbanEx.Country.CZ,
    "DE" => IbanEx.Country.DE,
    "DK" => IbanEx.Country.DK,
    "ES" => IbanEx.Country.ES,
    "EE" => IbanEx.Country.EE,
    "FR" => IbanEx.Country.FR,
    "FI" => IbanEx.Country.FI,
    "GB" => IbanEx.Country.GB,
    "HR" => IbanEx.Country.HR,
    "LT" => IbanEx.Country.LT,
    "LU" => IbanEx.Country.LU,
    "LV" => IbanEx.Country.LV,
    "MT" => IbanEx.Country.MT,
    "NL" => IbanEx.Country.NL,
    "PL" => IbanEx.Country.PL,
    "PT" => IbanEx.Country.PT,
    "UA" => IbanEx.Country.UA
  }

  @supported_country_codes Map.keys(@supported_countries)

  @spec supported_countries() :: map()
  defp supported_countries(), do: @supported_countries

  @spec supported_country_codes() :: [country_code()] | []
  def supported_country_codes(), do: @supported_country_codes

  @spec country_module(country_code) :: Module.t() | error_tuple()
  def country_module(country_code) when is_binary(country_code) or is_atom(country_code) do
    normalized_country_code = normalize(country_code)
    case is_country_code_supported?(normalized_country_code) do
      true -> supported_countries()[normalized_country_code]
      _ -> {:error, :unsupported_country_code}
    end
  end

  @spec is_country_code_supported?(country_code()) :: boolean()
  def is_country_code_supported?(country_code) when is_binary(country_code) or is_atom(country_code),
    do: Enum.member?(@supported_country_codes, normalize(country_code))
end
