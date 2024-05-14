defmodule IbanEx.Country.LT do
  @moduledoc """
  Lithuanian IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "LT",
      ...>    check_digits: "12",
      ...>    bank_code: "10000",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "11101001000"
      ...>  }
      ...>  |> IbanEx.Country.LT.to_string()
      "LT 12 10000 11101001000"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9]{11})$/i

  use IbanEx.Country.Template
end
