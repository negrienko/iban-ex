defmodule IbanEx.Country.PT do
  @moduledoc """
  Portugal IBAN parsing rules
  """

  @size 25
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{4})(?<account_number>[0-9]{11})(?<national_check>[0-9]{2})$/i

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
