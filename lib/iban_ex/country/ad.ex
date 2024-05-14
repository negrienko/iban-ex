defmodule IbanEx.Country.AD do
  @moduledoc """
  Andorra IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "AD",
      ...>    check_digits: "12",
      ...>    bank_code: "0001",
      ...>    branch_code: "2030",
      ...>    national_check: nil,
      ...>    account_number: "200359100100"
      ...>  }
      ...>  |> IbanEx.Country.AD.to_string()
      "AD 12 0001 2030 200359100100"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{4})(?<account_number>[0-9A-Z]{12})$/i

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
