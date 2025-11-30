defmodule IbanEx.Country.OM do
  @moduledoc """
  Oman IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "OM",
      ...>    check_digits: "81",
      ...>    bank_code: "018",
      ...>    account_number: "0000001299123456"
      ...>  }
      ...>  |> IbanEx.Country.OM.to_string()
      "OM 81 018 0000001299123456"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[A-Z0-9]{16})$/i

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
