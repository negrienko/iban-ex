defmodule IbanEx.Country.AE do
  @moduledoc """
  United Arab Emirates IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "AE",
      ...>    check_digits: "07",
      ...>    bank_code: "033",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "1234567890123456"
      ...>  }
      ...>  |> IbanEx.Country.AE.to_string()
      "AE 07 033 1234567890123456"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
