defmodule IbanEx.Country.IE do
  @moduledoc """
  Ireland IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "IE", check_digits: "29", bank_code: "AIBK", branch_code: "931152", national_check: nil, account_number: "12345678"}
    iex> |> IbanEx.Country.IE.to_string()
    "IE 29 AIBK 931152 12345678"

  """

  @size 22
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{6})(?<account_number>[0-9]{8})$/i

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
          national_check: _national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
