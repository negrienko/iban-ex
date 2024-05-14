defmodule IbanEx.Country.DO do
  @moduledoc """
  Dominican Republic IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "DO",
      ...>    check_digits: "28",
      ...>    bank_code: "BAGR",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00000001212453611324"
      ...>  }
      ...>  |> IbanEx.Country.DO.to_string()
      "DO 28 BAGR 00000001212453611324"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9A-Z]{4})(?<account_number>[0-9]{20})$/i

  use IbanEx.Country.Template
end
