defmodule IbanEx.Country.GT do
  @moduledoc """
  Guatemala IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "GT",
      ...>    check_digits: "82",
      ...>    bank_code: "TRAJ",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "01020000001210029690"
      ...>  }
      ...>  |> IbanEx.Country.GT.to_string()
      "GT 82 TRAJ 01020000001210029690"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{20})$/i

  use IbanEx.Country.Template
end
