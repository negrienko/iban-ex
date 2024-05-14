defmodule IbanEx.Country.KW do
  @moduledoc """
  Kuwait IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "KW",
      ...>    check_digits: "81",
      ...>    bank_code: "CBKU",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000000000001234560101"
      ...>  }
      ...>  |> IbanEx.Country.KW.to_string()
      "KW 81 CBKU 0000000000001234560101"
  ```
  """

  @size 30
  @rule ~r/^(?<bank_code>[A-Z0-9]{4})(?<account_number>[0-9]{22})$/i

  use IbanEx.Country.Template
end
