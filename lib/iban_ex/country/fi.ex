defmodule IbanEx.Country.FI do
  @moduledoc """
  Finland IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "FI", check_digits: "21", bank_code: "123456", branch_code: nil, national_check: "5", account_number: "0000078"}
    iex> |> IbanEx.Country.FI.to_string()
    "FI 21 123456 0000078 5"

  """

  @size 18
  @rule ~r/^(?<bank_code>[0-9]{6})(?<account_number>[0-9]{7})(?<national_check>[0-9]{1})$/i

  use IbanEx.Country.Template

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: _branch_code,
          national_check: national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, account_number, national_check]
    |> Enum.join(joiner)
  end
end
