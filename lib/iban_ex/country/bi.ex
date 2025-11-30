defmodule IbanEx.Country.BI do
  @moduledoc """
  Burundi IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BI",
      ...>    check_digits: "42",
      ...>    bank_code: "10000",
      ...>    branch_code: "10001",
      ...>    account_number: "00003320451",
      ...>    national_check: "81"
      ...>  }
      ...>  |> IbanEx.Country.BI.to_string()
      "BI 42 10000 10001 00003320451 81"
  ```
  """

  @size 27
  @rule ~r/^(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9]{11})(?<national_check>[0-9]{2})$/i

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
