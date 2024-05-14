defmodule IbanEx.Country.BH do
  @moduledoc """
  Bahrain IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BH",
      ...>    check_digits: "67",
      ...>    bank_code: "BMAG",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00001299123456"
      ...>  }
      ...>  |> IbanEx.Country.BH.to_string()
      "BH 67 BMAG 00001299123456"
  ```
  """

  @size 22
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{14})$/i

  use IbanEx.Country.Template
end
