defmodule IbanEx.Country.JO do
  @moduledoc """
  Jordan IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "JO",
      ...>    check_digits: "94",
      ...>    bank_code: "CBJO",
      ...>    branch_code: "0010",
      ...>    national_check: nil,
      ...>    account_number: "000000000131000302"
      ...>  }
      ...>  |> IbanEx.Country.JO.to_string()
      "JO 94 CBJO 0010 000000000131000302"
  ```
  """

  @size 30
  @rule ~r/^(?<bank_code>[A-Z0-9]{4})(?<branch_code>[0-9]{4})(?<account_number>[A-Z0-9]{18})$/i

  use IbanEx.Country.Template

  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: branch_code,
          national_check: _national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
