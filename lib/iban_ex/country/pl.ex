defmodule IbanEx.Country.PL do
  @moduledoc """
  Poland IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "PL", check_digits: "61", bank_code: "109", branch_code: "0101", national_check: "4", account_number: "0000071219812874"}
    iex> |> IbanEx.Country.PL.to_string()
    "PL 61 109 0101 4 0000071219812874"

  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{4})(?<national_check>[0-9]{1})(?<account_number>[0-9]{16})$/i

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
    [country_code, check_digits, bank_code, branch_code, national_check, account_number]
    |> Enum.join(joiner)
  end
end
