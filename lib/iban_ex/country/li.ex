defmodule IbanEx.Country.LI do
  @moduledoc """
  Liechtenstein IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "LI", check_digits: "21", bank_code: "08810", branch_code: nil, national_check: nil, account_number: "0002324013AA"}
    iex> |> IbanEx.Country.LI.to_string()
    "LI 21 08810 0002324013AA"

  """

  @size 21
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9A-Z]{12})$/i

  use IbanEx.Country.Template
end
