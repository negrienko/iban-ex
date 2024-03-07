defmodule IbanEx.Country.PL do
  @moduledoc """
  Poland IBAN parsing rules
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
