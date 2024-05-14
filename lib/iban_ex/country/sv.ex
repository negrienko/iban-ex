defmodule IbanEx.Country.SV do
  @moduledoc """
  El Salvador IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SV",
      ...>    check_digits: "62",
      ...>    bank_code: "CENR",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "00000000000000700025"
      ...>  }
      ...>  |> IbanEx.Country.SV.to_string()
      "SV 62 CENR 00000000000000700025"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z0-9]{4})(?<account_number>[0-9]{20})$/i

  use IbanEx.Country.Template
end
