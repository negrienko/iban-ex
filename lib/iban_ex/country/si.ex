defmodule IbanEx.Country.SI do
  @moduledoc """
  Slovenia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SI",
      ...>    check_digits: "56",
      ...>    bank_code: "26",
      ...>    branch_code: "330",
      ...>    national_check: "86",
      ...>    account_number: "00120390"
      ...>  }
      ...>  |> IbanEx.Country.SI.to_string()
      "SI 56 26 330 00120390 86"
  ```
  """

  @size 19
  @rule ~r/^(?<bank_code>[0-9]{2})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{8})(?<national_check>[0-9]{2})$/i

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
