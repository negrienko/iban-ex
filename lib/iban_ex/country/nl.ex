defmodule IbanEx.Country.NL do
  @moduledoc """
  Netherlands IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "NL", check_digits: "91", bank_code: "ABNA", branch_code: nil, national_check: nil, account_number: "0417164300"}
    iex> |> IbanEx.Country.NL.to_string()
    "NL 91 ABNA 0417164300"

  """

  @size 18
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
