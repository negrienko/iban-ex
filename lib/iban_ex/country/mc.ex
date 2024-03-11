defmodule IbanEx.Country.MC do
  @moduledoc """
  Monaco IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "MC", check_digits: "58", bank_code: "11222", branch_code: "00001", national_check: "30", account_number: "01234567890"}
    iex> |> IbanEx.Country.MC.to_string()
    "MC 58 11222 00001 01234567890 30"

  """

  @size 27
  @rule ~r/^(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{11})(?<national_check>[0-9]{2})$/i

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
