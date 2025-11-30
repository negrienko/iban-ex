defmodule IbanEx.Country.ST do
  @moduledoc """
  Sao Tome and Principe IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "ST",
      ...>    check_digits: "23",
      ...>    bank_code: "0001",
      ...>    branch_code: "0001",
      ...>    account_number: "00518453101",
      ...>    national_check: "46"
      ...>  }
      ...>  |> IbanEx.Country.ST.to_string()
      "ST 23 0001 0001 00518453101 46"
  ```
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
