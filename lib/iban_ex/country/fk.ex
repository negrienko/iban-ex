defmodule IbanEx.Country.FK do
  @moduledoc """
  Falkland Islands (Malvinas) IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "FK",
      ...>    check_digits: "88",
      ...>    bank_code: "SC",
      ...>    account_number: "123456789012"
      ...>  }
      ...>  |> IbanEx.Country.FK.to_string()
      "FK 88 SC 123456789012"
  ```
  """

  @size 18
  @rule ~r/^(?<bank_code>[A-Z]{2})(?<account_number>[0-9]{12})$/i

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
