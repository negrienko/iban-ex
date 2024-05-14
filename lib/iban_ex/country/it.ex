defmodule IbanEx.Country.IT do
  @moduledoc """
  Italy IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "IT",
      ...>    check_digits: "60",
      ...>    bank_code: "05428",
      ...>    branch_code: "11101",
      ...>    national_check: "X",
      ...>    account_number: "000000123456"
      ...>  }
      ...>  |> IbanEx.Country.IT.to_string()
      "IT 60 X 05428 11101 000000123456"
  ```
  """

  @size 27
  @rule ~r/^(?<national_check>[A-Z]{1})(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{12})$/i

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
          national_check: national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, national_check, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
