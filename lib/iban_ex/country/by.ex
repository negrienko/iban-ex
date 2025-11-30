defmodule IbanEx.Country.BY do
  @moduledoc """
  Belarus IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BY",
      ...>    check_digits: "13",
      ...>    bank_code: "NBRB",
      ...>    account_number: "3600900000002Z00AB00"
      ...>  }
      ...>  |> IbanEx.Country.BY.to_string()
      "BY 13 NBRB 3600900000002Z00AB00"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z0-9]{4})(?<account_number>[0-9]{4}[A-Z0-9]{16})$/i

  use IbanEx.Country.Template

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, account_number]
    |> Enum.join(joiner)
  end
end
