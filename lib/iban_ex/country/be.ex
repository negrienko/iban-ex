defmodule IbanEx.Country.BE do
  @moduledoc """
  Belgium IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BE",
      ...>    check_digits: "68",
      ...>    bank_code: "539",
      ...>    branch_code: nil,
      ...>    national_check: "34",
      ...>    account_number: "0075470"
      ...>  }
      ...>  |> IbanEx.Country.BE.to_string()
      "BE 68 539 0075470 34"
  ```
  """

  @size 16
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{7})(?<national_check>[0-9]{2})$/i

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
