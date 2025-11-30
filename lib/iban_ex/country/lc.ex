defmodule IbanEx.Country.LC do
  @moduledoc """
  Saint Lucia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "LC",
      ...>    check_digits: "55",
      ...>    bank_code: "HEMM",
      ...>    account_number: "000100010012001200023015"
      ...>  }
      ...>  |> IbanEx.Country.LC.to_string()
      "LC 55 HEMM 000100010012001200023015"
  ```
  """

  @size 32
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[A-Z0-9]{24})$/i

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
