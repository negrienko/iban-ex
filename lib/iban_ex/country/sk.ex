defmodule IbanEx.Country.SK do
  @moduledoc """
  Slovakia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SK",
      ...>    check_digits: "31",
      ...>    bank_code: "1200",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000198742637541"
      ...>  }
      ...>  |> IbanEx.Country.SK.to_string()
      "SK 31 1200 0000198742637541"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
