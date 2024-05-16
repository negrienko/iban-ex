defmodule IbanEx.Country.IS do
  # !TODO Iceland IBAN contains identification number (last 10 digits of account number)

  @moduledoc """
  Island IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "IS",
      ...>    check_digits: "14",
      ...>    bank_code: "0159",
      ...>    branch_code: "26",
      ...>    national_check: nil,
      ...>    account_number: "0076545510730339"
      ...>  }
      ...>  |> IbanEx.Country.IS.to_string()
      "IS 14 0159 26 0076545510730339"
  ```
  """

  @size 26
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{2})(?<account_number>[0-9]{16})$/i

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
