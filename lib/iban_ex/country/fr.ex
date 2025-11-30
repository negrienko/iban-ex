defmodule IbanEx.Country.FR do
  @moduledoc """
  France IBAN parsing rules

  According to SWIFT registry and Wise validation, France BBAN structure is:
  - Bank code: 5 digits
  - Branch code: 5 digits
  - Account number: 11 alphanumeric characters
  - National check: 2 digits

  BBAN spec: 5!n5!n11!c2!n (total 23 chars)
  Example: FR1420041010050500013M02606
  - Bank: 20041
  - Branch: 01005
  - Account: 0500013M026
  - National check: 06

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "FR",
      ...>    check_digits: "14",
      ...>    bank_code: "20041",
      ...>    branch_code: "01005",
      ...>    account_number: "0500013M026",
      ...>    national_check: "06"
      ...>  }
      ...>  |> IbanEx.Country.FR.to_string()
      "FR 14 20041 01005 0500013M026 06"
  ```
  """

  @size 27
  @rule ~r/^(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{11})(?<national_check>[0-9]{2})$/i

  use IbanEx.Country.Template

  alias IbanEx.Iban

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: branch_code,
          account_number: account_number,
          national_check: national_check
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number, national_check]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(joiner)
  end
end
