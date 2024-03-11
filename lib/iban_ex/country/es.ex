defmodule IbanEx.Country.ES do
  @moduledoc """
  Spain IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "ES", check_digits: "91", bank_code: "2100", branch_code: "0418", national_check: "45", account_number: "0200051332"}
    iex> |> IbanEx.Country.ES.to_string()
    "ES 91 2100 0418 45 0200051332"

  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{4})(?<national_check>[0-9]{2})(?<account_number>[0-9]{10})$/i

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
