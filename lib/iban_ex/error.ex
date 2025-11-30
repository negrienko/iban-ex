defmodule IbanEx.Error do
  @moduledoc false

  @type error() ::
          :unsupported_country_code
          | :invalid_format
          | :invalid_length
          | :invalid_checksum
          | :can_not_parse_map
          | :length_to_long
          | :length_to_short
          | :invalid_bank_code
          | :invalid_account_number
          | :invalid_branch_code
          | :invalid_national_check
          | atom()
  @type errors() :: [error()]
  @errors [
    :unsupported_country_code,
    :invalid_format,
    :invalid_length,
    :invalid_checksum,
    :can_not_parse_map,
    :length_to_long,
    :length_to_short,
    :invalid_bank_code,
    :invalid_account_number,
    :invalid_branch_code,
    :invalid_national_check
  ]

  @messages [
    unsupported_country_code: "Unsupported country code",
    invalid_format: "IBAN violates required format",
    invalid_length: "IBAN violates the required length",
    invalid_checksum: "IBAN's checksum is invalid",
    can_not_parse_map: "Can't parse map to IBAN struct",
    length_to_long: "IBAN longer then required length",
    length_to_short: "IBAN shorter then required length",
    invalid_bank_code: "Bank code violates required format",
    invalid_account_number: "Account number violates required format",
    invalid_branch_code: "Branch code violates required format",
    invalid_national_check: "National check symbols violates required format"
  ]

  @spec message(error()) :: String.t()
  def message(error) when error in @errors, do: @messages[error]
  def message(_error), do: "Undefined error"
end
