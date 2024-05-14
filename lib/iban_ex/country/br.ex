defmodule IbanEx.Country.BR do
  @moduledoc """
  Brazil IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BR",
      ...>    check_digits: "18",
      ...>    bank_code: "00360305",
      ...>    branch_code: "00001",
      ...>    account_number: "0009795493",
      ...>    national_check: "C1"
      ...>  }
      ...>  |> IbanEx.Country.BR.to_string()
      "BR 18 00360305 00001 0009795493 C1"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[0-9]{8})(?<branch_code>[0-9]{5})(?<account_number>[0-9]{10})(?<national_check>[A-Z]{1}[0-9A-Z]{1})$/i

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
          account_number: account_number,
          national_check: national_check
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number, national_check]
    |> Enum.join(joiner)
  end
end
