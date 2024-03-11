defmodule IbanEx.Country.CH do
  @moduledoc """
  Switzerland IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "CH", check_digits: "93", bank_code: "00762", branch_code: nil, national_check: nil, account_number: "011623852957"}
    iex> |> IbanEx.Country.CH.to_string()
    "CH 93 00762 011623852957"

  """

  @size 21
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9A-Z]{12})$/i

  use IbanEx.Country.Template
end
