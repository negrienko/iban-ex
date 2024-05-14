defmodule IbanEx.Country.SA do
  @moduledoc """
  Saudi Arabia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SA",
      ...>    check_digits: "03",
      ...>    bank_code: "80",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "000000608010167519"
      ...>  }
      ...>  |> IbanEx.Country.SA.to_string()
      "SA 03 80 000000608010167519"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{2})(?<account_number>[0-9]{18})$/i

  use IbanEx.Country.Template
end
