defmodule IbanEx.Country.NI do
  @moduledoc """
  Nicaragua IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "NI",
      ...>    check_digits: "45",
      ...>    bank_code: "BAPR",
      ...>    account_number: "00000013000003558124"
      ...>  }
      ...>  |> IbanEx.Country.NI.to_string()
      "NI 45 BAPR 00000013000003558124"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{20})$/i

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
