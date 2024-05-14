defmodule IbanEx.Country.QA do
  @moduledoc """
  Qatar IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "QA",
      ...>    check_digits: "58",
      ...>    bank_code: "DOHB",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00001234567890ABCDEFG"
      ...>  }
      ...>  |> IbanEx.Country.QA.to_string()
      "QA 58 DOHB 00001234567890ABCDEFG"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[A-Z0-9]{21})$/i

  use IbanEx.Country.Template
end
