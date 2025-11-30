defmodule IbanEx.Country.DJ do
  @moduledoc """
  Djibouti IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "DJ",
      ...>    check_digits: "21",
      ...>    bank_code: "00010",
      ...>    branch_code: "00000",
      ...>    account_number: "01540001001",
      ...>    national_check: "86"
      ...>  }
      ...>  |> IbanEx.Country.DJ.to_string()
      "DJ 21 00010 00000 01540001001 86"
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
