defmodule IbanEx.Country.HU do
  @moduledoc """
  Hungary IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "HU", check_digits: "42", bank_code: "117", branch_code: "7301", national_check: "0", account_number: "6111110180000000"}
    iex> |> IbanEx.Country.HU.to_string()
    "HU 42 117 7301 6111110180000000 0"

  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{4})(?<account_number>[0-9]{16})(?<national_check>[0-9]{1})$/i

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
