defmodule IbanEx.Country.KZ do
  @moduledoc """
  Kazakhstan IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "KZ",
      ...>    check_digits: "86",
      ...>    bank_code: "125",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "KZT5004100100"
      ...>  }
      ...>  |> IbanEx.Country.KZ.to_string()
      "KZ 86 125 KZT5004100100"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[A-Z0-9]{13})$/i

  use IbanEx.Country.Template
end
