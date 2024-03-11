defmodule IbanEx.Country.DE do
  @moduledoc """
  Germany IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "DE", check_digits: "89", bank_code: "37040044", branch_code: nil, national_check: nil, account_number: "0532013000"}
    iex> |> IbanEx.Country.DE.to_string()
    "DE 89 37040044 0532013000"

  """

  @size 22
  @rule ~r/^(?<bank_code>[0-9]{8})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
