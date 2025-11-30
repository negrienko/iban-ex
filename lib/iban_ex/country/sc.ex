defmodule IbanEx.Country.SC do
  @moduledoc """
  Seychelles IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SC",
      ...>    check_digits: "18",
      ...>    bank_code: "SSCB11",
      ...>    branch_code: "01",
      ...>    account_number: "0000000000001497USD"
      ...>  }
      ...>  |> IbanEx.Country.SC.to_string()
      "SC 18 SSCB11 01 0000000000001497USD"
  ```
  """

  @size 31
  @rule ~r/^(?<bank_code>[A-Z]{4}[0-9]{2})(?<branch_code>[0-9]{2})(?<account_number>[0-9]{16}[A-Z]{3})$/i

  use IbanEx.Country.Template

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: branch_code,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
