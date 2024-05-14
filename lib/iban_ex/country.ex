defmodule IbanEx.Country do
  @moduledoc false

  import IbanEx.Commons, only: [normalize: 1]

  @type country_code() :: <<_::16>> | atom()
  @type error_tuple() :: {:error, atom()}

  @supported_countries %{
    "AD" => IbanEx.Country.AD,
    "AE" => IbanEx.Country.AE,
    "AL" => IbanEx.Country.AL,
    "AT" => IbanEx.Country.AT,
    "AZ" => IbanEx.Country.AZ,
    "BA" => IbanEx.Country.BA,
    "BE" => IbanEx.Country.BE,
    "BG" => IbanEx.Country.BG,
    "BH" => IbanEx.Country.BH,
    "BR" => IbanEx.Country.BR,
    "CH" => IbanEx.Country.CH,
    "CR" => IbanEx.Country.CR,
    "CY" => IbanEx.Country.CY,
    "CZ" => IbanEx.Country.CZ,
    "DE" => IbanEx.Country.DE,
    "DO" => IbanEx.Country.DO,
    "DK" => IbanEx.Country.DK,
    "EE" => IbanEx.Country.EE,
    "ES" => IbanEx.Country.ES,
    "EG" => IbanEx.Country.EG,
    "FI" => IbanEx.Country.FI,
    "FR" => IbanEx.Country.FR,
    "FO" => IbanEx.Country.FO,
    "GB" => IbanEx.Country.GB,
    "GE" => IbanEx.Country.GE,
    "GI" => IbanEx.Country.GI,
    "GL" => IbanEx.Country.GL,
    "GR" => IbanEx.Country.GR,
    "GT" => IbanEx.Country.GT,
    "HR" => IbanEx.Country.HR,
    "HU" => IbanEx.Country.HU,
    "IE" => IbanEx.Country.IE,
    "IL" => IbanEx.Country.IL,
    "IT" => IbanEx.Country.IT,
    "JO" => IbanEx.Country.JO,
    "KZ" => IbanEx.Country.KZ,
    "KW" => IbanEx.Country.KW,
    "LB" => IbanEx.Country.LB,
    "LI" => IbanEx.Country.LI,
    "LT" => IbanEx.Country.LT,
    "LU" => IbanEx.Country.LU,
    "LV" => IbanEx.Country.LV,
    "MC" => IbanEx.Country.MC,
    "MD" => IbanEx.Country.MD,
    "ME" => IbanEx.Country.ME,
    "MK" => IbanEx.Country.MK,
    "MR" => IbanEx.Country.MR,
    "MT" => IbanEx.Country.MT,
    "NL" => IbanEx.Country.NL,
    "NO" => IbanEx.Country.NO,
    "PL" => IbanEx.Country.PL,
    "PT" => IbanEx.Country.PT,
    "PK" => IbanEx.Country.PK,
    "QA" => IbanEx.Country.QA,
    "RO" => IbanEx.Country.RO,
    "RS" => IbanEx.Country.RS,
    "SA" => IbanEx.Country.SA,
    "SE" => IbanEx.Country.SE,
    "SI" => IbanEx.Country.SI,
    "SK" => IbanEx.Country.SK,
    "SM" => IbanEx.Country.SM,
    "SV" => IbanEx.Country.SV,
    "TL" => IbanEx.Country.TL,
    "TR" => IbanEx.Country.TR,
    "UA" => IbanEx.Country.UA,
    "VA" => IbanEx.Country.VA,
    "VG" => IbanEx.Country.VG,
    "XK" => IbanEx.Country.XK
  }

  @supported_country_codes Map.keys(@supported_countries)
  @supported_country_modules Map.values(@supported_countries)

  @spec supported_countries() :: map()
  defp supported_countries(), do: @supported_countries

  @spec supported_country_codes() :: [country_code()] | []
  def supported_country_codes(), do: @supported_country_codes

  @spec supported_country_modules() :: [module()] | []
  def supported_country_modules(), do: @supported_country_modules

  @spec country_module(country_code) :: module() | error_tuple()
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
