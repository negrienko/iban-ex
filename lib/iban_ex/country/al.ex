defmodule IbanEx.Country.AL do
  @moduledoc """
  Albania IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "AL",
      ...>    check_digits: "47",
      ...>    bank_code: "212",
      ...>    branch_code: "1100",
      ...>    national_check: "9",
      ...>    account_number: "0000000235698741"
      ...>  }
      ...>  |> IbanEx.Country.AL.to_string()
      "AL 47 212 1100 9 0000000235698741"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{4})(?<national_check>[0-9]{1})(?<account_number>[0-9A-Z]{16})$/i

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
