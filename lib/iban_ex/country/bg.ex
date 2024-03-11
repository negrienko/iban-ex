defmodule IbanEx.Country.BG do
  @moduledoc """
  Bulgaria IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "BG", check_digits: "80", bank_code: "BNBG", branch_code: "9661", national_check: nil, account_number: "1020345678"}
    iex> |> IbanEx.Country.BG.to_string()
    "BG 80 BNBG 9661 1020345678"

  """

  @size 22
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{4})(?<account_number>[0-9]{2}[0-9A-Z]{8})$/i

  use IbanEx.Country.Template

  @spec size() :: 22

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
