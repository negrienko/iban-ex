defmodule IbanEx.Country.VA do
  @moduledoc """
  Vatican IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "VA", check_digits: "59", bank_code: "001", branch_code: nil, national_check: nil, account_number: "123000012345678"}
    iex> |> IbanEx.Country.VA.to_string()
    "VA 59 001 123000012345678"

  """

  @size 22
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{15})$/i

  use IbanEx.Country.Template
end
