defmodule IbanEx.Country.UA do
  @moduledoc """
  Ukrainian IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "UA",
      ...>    check_digits: "21",
      ...>    bank_code: "322313",
      ...>    branch_code: nil,
      ...>    national_check: nil,
      ...>    account_number: "0000026007233566001"
      ...>  }
      ...>  |> IbanEx.Country.UA.to_string()
      "UA 21 322313 0000026007233566001"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[0-9]{6})(?<account_number>[0-9A-Z]{19})$/i
  use IbanEx.Country.Template
end
