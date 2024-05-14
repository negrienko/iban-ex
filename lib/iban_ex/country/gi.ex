defmodule IbanEx.Country.GI do
  @moduledoc """
  Gibraltar IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "GI",
      ...>    check_digits: "75",
      ...>    bank_code: "NWBK",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "000000007099453"
      ...>  }
      ...>  |> IbanEx.Country.GI.to_string()
      "GI 75 NWBK 000000007099453"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9A-Z]{15})$/i

  use IbanEx.Country.Template
end
