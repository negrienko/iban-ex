defmodule IbanEx.Country.CZ do
  @moduledoc """
  Czech Republic IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "CZ", check_digits: "65", bank_code: "0800", branch_code: nil, national_check: nil, account_number: "0000192000145399"}
    iex> |> IbanEx.Country.CZ.to_string()
    "CZ 65 0800 0000192000145399"

  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
