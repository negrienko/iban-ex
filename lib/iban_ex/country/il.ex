defmodule IbanEx.Country.IL do
  @moduledoc """
  Israel IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "IL",
      ...>    check_digits: "62",
      ...>    bank_code: "010",
      ...>    branch_code: "800",
      ...>    national_check: nil,
      ...>    account_number: "0000099999999"
      ...>  }
      ...>  |> IbanEx.Country.IL.to_string()
      "IL 62 010 800 0000099999999"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{13})$/i

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
