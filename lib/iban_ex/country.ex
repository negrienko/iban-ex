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
    "EE" => IbanEx.Country.EE,
    "ES" => IbanEx.Country.ES,
    "FI" => IbanEx.Country.FI,
    "FR" => IbanEx.Country.FR,
    "GB" => IbanEx.Country.GB,
    "GI" => IbanEx.Country.GI,
    "GR" => IbanEx.Country.GR,
    "HR" => IbanEx.Country.HR,
    "HU" => IbanEx.Country.HU,
    "IE" => IbanEx.Country.IE,
    "IT" => IbanEx.Country.IT,
    "LI" => IbanEx.Country.LI,
    "LT" => IbanEx.Country.LT,
    "LU" => IbanEx.Country.LU,
    "LV" => IbanEx.Country.LV,
    "MC" => IbanEx.Country.MC,
    "MT" => IbanEx.Country.MT,
    "NL" => IbanEx.Country.NL,
    "NO" => IbanEx.Country.NO,
    "PL" => IbanEx.Country.PL,
    "PT" => IbanEx.Country.PT,
    "RO" => IbanEx.Country.RO,
    "SE" => IbanEx.Country.SE,
    "SM" => IbanEx.Country.SM,
    "SI" => IbanEx.Country.SI,
    "SK" => IbanEx.Country.SK,
    "UA" => IbanEx.Country.UA,
    "VA" => IbanEx.Country.VA
  }

  @supported_country_codes Map.keys(@supported_countries)
  @supported_country_modules Map.values(@supported_countries)

  @spec supported_countries() :: map()
  defp supported_countries(), do: @supported_countries

  @spec supported_country_codes() :: [country_code()] | []
  def supported_country_codes(), do: @supported_country_codes

  @spec supported_country_modules() :: [module()] | []
  def supported_country_modules(), do: @supported_country_modules

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
