defmodule IbanEx.Country.GB do
  @moduledoc """
  United Kingdom IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "GB", check_digits: "29", bank_code: "NWBK", branch_code: "601613", national_check: "06", account_number: "31926819"}
    iex> |> IbanEx.Country.GB.to_string()
    "GB 29 NWBK 601613 31926819"

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
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
