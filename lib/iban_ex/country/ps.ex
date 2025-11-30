defmodule IbanEx.Country.PS do
  @moduledoc """
  Palestine IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "PS",
      ...>    check_digits: "92",
      ...>    bank_code: "PALS",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "000000000400123456702"
      ...>  }
      ...>  |> IbanEx.Country.PS.to_string()
      "PS 92 PALS 000000000400123456702"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[A-Z0-9]{21})$/i

  use IbanEx.Country.Template
end

