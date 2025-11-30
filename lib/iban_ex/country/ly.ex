defmodule IbanEx.Country.LY do
  @moduledoc """
  Libya IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "LY",
      ...>    check_digits: "83",
      ...>    bank_code: "002",
      ...>    branch_code: "048",
      ...>    account_number: "000020100120361"
      ...>  }
      ...>  |> IbanEx.Country.LY.to_string()
      "LY 83 002 048 000020100120361"
  ```
  """

  @size 25
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{15})$/i

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
