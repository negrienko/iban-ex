defmodule IbanEx.Country.SM do
  @moduledoc """
  San Marino IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SM",
      ...>    check_digits: "86",
      ...>    bank_code: "03225",
      ...>    branch_code: "09800",
      ...>    national_check: "U",
      ...>    account_number: "000000270100"
      ...>  }
      ...>  |> IbanEx.Country.SM.to_string()
      "SM 86 U 03225 09800 000000270100"
  ```
  """

  @size 27
  @rule ~r/^(?<national_check>[A-Z]{1})(?<bank_code>[0-9]{5})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{12})$/i

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
    [country_code, check_digits, national_check, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
