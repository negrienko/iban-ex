defmodule IbanEx.Country.MK do
  @moduledoc """
  Macedonia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MK",
      ...>    check_digits: "07",
      ...>    bank_code: "250",
      ...>    branch_code: nil,
      ...>    national_check: "84",
      ...>    account_number: "1200000589"
      ...>  }
      ...>  |> IbanEx.Country.MK.to_string()
      "MK 07 250 1200000589 84"
  ```
  """

  @size 19
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{10})(?<national_check>[0-9]{2})$/i

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
