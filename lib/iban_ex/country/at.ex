defmodule IbanEx.Country.AT do
  @moduledoc """
  Austria IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "AT", check_digits: "61", bank_code: "19043", branch_code: nil, national_check: nil, account_number: "00234573201"}
    iex> |> IbanEx.Country.UA.to_string()
    "AT 61 19043 00234573201"

  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9]{11})$/i

  use IbanEx.Country.Template
end
