defmodule IbanEx.Country.LU do
  @moduledoc """
  Luxembourg IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "LU", check_digits: "28", bank_code: "001", branch_code: nil, national_check: nil, account_number: "9400644750000"}
    iex> |> IbanEx.Country.LU.to_string()
    "LU 28 001 9400644750000"

  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9A-Z]{13})$/i

  use IbanEx.Country.Template
end
