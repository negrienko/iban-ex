defmodule IbanEx.Country.LV do
  @moduledoc """
  Latvian IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "LV",
      ...>    check_digits: "80",
      ...>    bank_code: "BANK",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000435195001"
      ...>  }
      ...>  |> IbanEx.Country.LV.to_string()
      "LV 80 BANK 0000435195001"
  ```
  """

  @size 21
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9A-Z]{13})$/i

  use IbanEx.Country.Template
end
