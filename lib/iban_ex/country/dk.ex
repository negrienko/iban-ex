defmodule IbanEx.Country.DK do
  @moduledoc """
  Denmark IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "DK", check_digits: "50", bank_code: "0040", branch_code: nil, national_check: nil, account_number: "0440116243"}
    iex> |> IbanEx.Country.DK.to_string()
    "DK 50 0040 0440116243"

  """
  @size 18
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
