defmodule IbanEx.Country.PK do
  @moduledoc """
  Pakistan IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "PK",
      ...>    check_digits: "36",
      ...>    bank_code: "SCBL",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000001123456702"
      ...>  }
      ...>  |> IbanEx.Country.PK.to_string()
      "PK 36 SCBL 0000001123456702"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
