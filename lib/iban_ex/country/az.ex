defmodule IbanEx.Country.AZ do
  @moduledoc """
  Azerbaijan IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "AZ",
      ...>    check_digits: "21",
      ...>    bank_code: "NABZ",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00000000137010001944"
      ...>  }
      ...>  |> IbanEx.Country.AZ.to_string()
      "AZ 21 NABZ 00000000137010001944"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9A-Z]{20})$/i

  use IbanEx.Country.Template
end
