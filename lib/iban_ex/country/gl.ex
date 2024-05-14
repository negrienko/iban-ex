defmodule IbanEx.Country.GL do
  @moduledoc """
  Greenland IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "GL",
      ...>    check_digits: "89",
      ...>    bank_code: "6471",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0001000206"
      ...>  }
      ...>  |> IbanEx.Country.GL.to_string()
      "GL 89 6471 0001000206"
  ```
  """

  @size 18
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
