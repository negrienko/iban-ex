defmodule IbanEx.Country.CY do
  @moduledoc """
  Cyprus IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "CY",
      ...>    check_digits: "17",
      ...>    bank_code: "002",
      ...>    branch_code: "00128",
      ...>    national_check: nil,
      ...>    account_number: "0000001200527600"
      ...>  }
      ...>  |> IbanEx.Country.CY.to_string()
      "CY 17 002 00128 0000001200527600"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{16})$/i

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
          national_check: _national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
