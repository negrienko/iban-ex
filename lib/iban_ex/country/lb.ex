defmodule IbanEx.Country.LB do
  @moduledoc """
  Lebanon IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "LB",
      ...>    check_digits: "62",
      ...>    bank_code: "0999",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00000001001901229114"
      ...>  }
      ...>  |> IbanEx.Country.LB.to_string()
      "LB 62 0999 00000001001901229114"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{20})$/i

  use IbanEx.Country.Template
end
