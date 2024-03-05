defmodule IbanEx.Error do
  @moduledoc """

  """

  @type error() ::
          :unsupported_country_code
          | :invalid_format
          | :invalid_length
          | :invalid_checksum
          | :can_not_parse_map
          | atom()
  @type errors() :: [error()]
  @errors [
    :unsupported_country_code,
    :invalid_format,
    :invalid_length,
    :invalid_checksum,
    :can_not_parse_map
  ]

  @messages [
    unsupported_country_code: "Unsupported country code",
    invalid_format: "IBAN violates required format",
    invalid_length: "IBAN violates the required length",
    invalid_checksum: "IBAN's checksum is invalid",
    can_not_parse_map: "Can't parse map to IBAN struct"
  ]

  @spec message(error()) :: String.t()
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
