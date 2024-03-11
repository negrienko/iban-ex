defmodule IbanEx.Country.HR do
  @moduledoc """
  Croatia IBAN parsing rules

  ## Examples

    iex> %IbanEx.Iban{country_code: "HR", check_digits: "12", bank_code: "1001005", branch_code: nil, national_check: nil, account_number: "1863000160"}
    iex> |> IbanEx.Country.HR.to_string()
    "HR 12 1001005 1863000160"

  """

  @size 21
  @rule ~r/^(?<bank_code>[0-9]{7})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
