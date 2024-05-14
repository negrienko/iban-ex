defmodule IbanEx.Country.ME do
  @moduledoc """
  Montenegro IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "ME",
      ...>    check_digits: "25",
      ...>    bank_code: "505",
      ...>    branch_code: nil,
      ...>    national_check: "51",
      ...>    account_number: "0000123456789"
      ...>  }
      ...>  |> IbanEx.Country.ME.to_string()
      "ME 25 505 0000123456789 51"
  ```
  """

  @size 22
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{13})(?<national_check>[0-9]{2})$/i

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
