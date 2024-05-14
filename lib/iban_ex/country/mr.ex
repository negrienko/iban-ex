defmodule IbanEx.Country.MR do
  @moduledoc """
  Mauritania IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MR",
      ...>    check_digits: "13",
      ...>    bank_code: "00020",
      ...>    branch_code: "00101",
      ...>    national_check: "53",
      ...>    account_number: "00001234567"
      ...>  }
      ...>  |> IbanEx.Country.MR.to_string()
      "MR 13 00020 00101 00001234567 53"
  ```
  """

  @size 27
  @rule ~r/^(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9]{11})(?<national_check>[0-9]{2})$/i

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
    [country_code, check_digits, bank_code, branch_code, account_number, national_check]
    |> Enum.join(joiner)
  end
end
