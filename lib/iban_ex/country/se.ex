defmodule IbanEx.Country.SE do
  @moduledoc """
  Sweden IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "SE", check_digits: "45", bank_code: "500", branch_code: nil, national_check: nil, account_number: "00000058398257466"}
    iex> |> IbanEx.Country.SE.to_string()
    "SE 45 500 00000058398257466"

  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{17})$/i

  use IbanEx.Country.Template
end
