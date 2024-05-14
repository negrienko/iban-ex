defmodule IbanEx.Country.RO do
  @moduledoc """
  Romania IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "RO",
      ...>    check_digits: "49",
      ...>    bank_code: "AAAA",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "1B31007593840000"
      ...>  }
      ...>  |> IbanEx.Country.RO.to_string()
      "RO 49 AAAA 1B31007593840000"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9A-Z]{16})$/i

  use IbanEx.Country.Template
end
