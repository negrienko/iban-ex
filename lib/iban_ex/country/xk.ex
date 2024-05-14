defmodule IbanEx.Country.XK do
  @moduledoc """
  Kosovo IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "XK",
      ...>    check_digits: "05",
      ...>    bank_code: "12",
      ...>    branch_code: "12",
      ...>    national_check: "06",
      ...>    account_number: "0123456789"
      ...>  }
      ...>  |> IbanEx.Country.XK.to_string()
      "XK 05 12 12 0123456789 06"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{2})(?<branch_code>[0-9]{2})(?<account_number>[0-9]{10})(?<national_check>[0-9]{2})$/i

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
