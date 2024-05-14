defmodule IbanEx.Country.CR do
  @moduledoc """
  Costa Rica IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "CR",
      ...>    check_digits: "05",
      ...>    bank_code: "0152",
      ...>    branch_code: nil,
      ...>    account_number: "02001026284066",
      ...>    national_check: nil
      ...>  }
      ...>  |> IbanEx.Country.CR.to_string()
      "CR 05 0152 02001026284066"
  ```
  """

  @size 22
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{14})$/i

  use IbanEx.Country.Template
end
