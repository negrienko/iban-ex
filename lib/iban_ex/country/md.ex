defmodule IbanEx.Country.MD do
  @moduledoc """
  Republic of Moldova IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MD",
      ...>    check_digits: "24",
      ...>    bank_code: "AG",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "000225100013104168"
      ...>  }
      ...>  |> IbanEx.Country.MD.to_string()
      "MD 24 AG 000225100013104168"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[A-Z]{2})(?<account_number>[0-9]{18})$/i

  use IbanEx.Country.Template
end
