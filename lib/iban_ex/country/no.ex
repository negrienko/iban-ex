defmodule IbanEx.Country.NO do
  @moduledoc """
  Norway IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "NO",
      ...>    check_digits: "93",
      ...>    bank_code: "8601",
      ...>    branch_code: nil,
      ...>    national_check: "7",
      ...>    account_number: "111794"
      ...>  }
      ...>  |> IbanEx.Country.NO.to_string()
      "NO 93 8601 111794 7"
  ```
  """

  @size 15
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{6})(?<national_check>[0-9]{1})$/i

  use IbanEx.Country.Template

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: _branch_code,
          national_check: national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, account_number, national_check]
    |> Enum.join(joiner)
  end
end
