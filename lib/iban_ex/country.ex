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
    "AX" => IbanEx.Country.FI,
    "AZ" => IbanEx.Country.AZ,
    "BA" => IbanEx.Country.BA,
    "BE" => IbanEx.Country.BE,
    "BG" => IbanEx.Country.BG,
    "BH" => IbanEx.Country.BH,
    "BI" => IbanEx.Country.BI,
    "BL" => IbanEx.Country.FR,
    "BR" => IbanEx.Country.BR,
    "BY" => IbanEx.Country.BY,
    "CH" => IbanEx.Country.CH,
    "CR" => IbanEx.Country.CR,
    "CY" => IbanEx.Country.CY,
    "CZ" => IbanEx.Country.CZ,
    "DE" => IbanEx.Country.DE,
    "DJ" => IbanEx.Country.DJ,
    "DK" => IbanEx.Country.DK,
    "DO" => IbanEx.Country.DO,
    "EE" => IbanEx.Country.EE,
    "EG" => IbanEx.Country.EG,
    "ES" => IbanEx.Country.ES,
    "FI" => IbanEx.Country.FI,
    "FK" => IbanEx.Country.FK,
    "FO" => IbanEx.Country.FO,
    "FR" => IbanEx.Country.FR,
    "GB" => IbanEx.Country.GB,
    "GE" => IbanEx.Country.GE,
    "GF" => IbanEx.Country.FR,
    "GG" => IbanEx.Country.GB,
    "GI" => IbanEx.Country.GI,
    "GL" => IbanEx.Country.GL,
    "GP" => IbanEx.Country.FR,
    "GR" => IbanEx.Country.GR,
    "GT" => IbanEx.Country.GT,
    "HN" => IbanEx.Country.HN,
    "HR" => IbanEx.Country.HR,
    "HU" => IbanEx.Country.HU,
    "IE" => IbanEx.Country.IE,
    "IL" => IbanEx.Country.IL,
    "IM" => IbanEx.Country.GB,
    "IQ" => IbanEx.Country.IQ,
    "IS" => IbanEx.Country.IS,
    "IT" => IbanEx.Country.IT,
    "JE" => IbanEx.Country.GB,
    "JO" => IbanEx.Country.JO,
    "KW" => IbanEx.Country.KW,
    "KZ" => IbanEx.Country.KZ,
    "LB" => IbanEx.Country.LB,
    "LC" => IbanEx.Country.LC,
    "LI" => IbanEx.Country.LI,
    "LT" => IbanEx.Country.LT,
    "LU" => IbanEx.Country.LU,
    "LV" => IbanEx.Country.LV,
    "LY" => IbanEx.Country.LY,
    "MC" => IbanEx.Country.MC,
    "MD" => IbanEx.Country.MD,
    "ME" => IbanEx.Country.ME,
    "MF" => IbanEx.Country.FR,
    "MK" => IbanEx.Country.MK,
    "MN" => IbanEx.Country.MN,
    "MQ" => IbanEx.Country.FR,
    "MR" => IbanEx.Country.MR,
    "MT" => IbanEx.Country.MT,
    "MU" => IbanEx.Country.MU,
    "NC" => IbanEx.Country.FR,
    "NI" => IbanEx.Country.NI,
    "NL" => IbanEx.Country.NL,
    "NO" => IbanEx.Country.NO,
    "OM" => IbanEx.Country.OM,
    "PF" => IbanEx.Country.FR,
    "PK" => IbanEx.Country.PK,
    "PL" => IbanEx.Country.PL,
    "PM" => IbanEx.Country.FR,
    "PS" => IbanEx.Country.PS,
    "PT" => IbanEx.Country.PT,
    "QA" => IbanEx.Country.QA,
    "RE" => IbanEx.Country.FR,
    "RO" => IbanEx.Country.RO,
    "RS" => IbanEx.Country.RS,
    "RU" => IbanEx.Country.RU,
    "SA" => IbanEx.Country.SA,
    "SC" => IbanEx.Country.SC,
    "SD" => IbanEx.Country.SD,
    "SE" => IbanEx.Country.SE,
    "SI" => IbanEx.Country.SI,
    "SK" => IbanEx.Country.SK,
    "SM" => IbanEx.Country.SM,
    "SO" => IbanEx.Country.SO,
    "ST" => IbanEx.Country.ST,
    "SV" => IbanEx.Country.SV,
    "TF" => IbanEx.Country.FR,
    "TL" => IbanEx.Country.TL,
    "TN" => IbanEx.Country.TN,
    "TR" => IbanEx.Country.TR,
    "UA" => IbanEx.Country.UA,
    "VA" => IbanEx.Country.VA,
    "VG" => IbanEx.Country.VG,
    "WF" => IbanEx.Country.FR,
    "XK" => IbanEx.Country.XK,
    "YE" => IbanEx.Country.YE,
    "YT" => IbanEx.Country.FR
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
  def is_country_code_supported?(country_code)
      when is_binary(country_code) or is_atom(country_code),
      do: Enum.member?(@supported_country_codes, normalize(country_code))
end
