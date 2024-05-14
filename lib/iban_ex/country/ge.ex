defmodule IbanEx.Country.GE do
  @moduledoc """
  Georgia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "GE",
      ...>    check_digits: "29",
      ...>    bank_code: "NB",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000000101904917"
      ...>  }
      ...>  |> IbanEx.Country.GE.to_string()
      "GE 29 NB 0000000101904917"
  ```
  """

  @size 22
  @rule ~r/^(?<bank_code>[A-Z]{2})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
