defmodule IbanEx.Country.EE do
  @moduledoc """
  Estonian IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "EE",
      ...>    check_digits: "38",
      ...>    bank_code: "22",
      ...>    branch_code: "00",
      ...>    national_check: "5",
      ...>    account_number: "22102014568"
      ...>  }
      ...>  |> IbanEx.Country.EE.to_string()
      "EE 38 22 00 22102014568 5"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{2})(?<branch_code>[0-9]{2})(?<account_number>[0-9]{11})(?<national_check>[0-9]{1})$/i

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
