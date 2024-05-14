defmodule IbanEx.Country.VG do
  @moduledoc """
  British Virgin Islands IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "VG",
      ...>    check_digits: "96",
      ...>    bank_code: "VPVG",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000012345678901"
      ...>  }
      ...>  |> IbanEx.Country.VG.to_string()
      "VG 96 VPVG 0000012345678901"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
