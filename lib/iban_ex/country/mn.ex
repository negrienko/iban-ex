defmodule IbanEx.Country.MN do
  @moduledoc """
  Mongolia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MN",
      ...>    check_digits: "12",
      ...>    bank_code: "1234",
      ...>    account_number: "123456789123"
      ...>  }
      ...>  |> IbanEx.Country.MN.to_string()
      "MN 12 1234 123456789123"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{12})$/i

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
