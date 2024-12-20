defmodule IbanEx.Country.BA do
  @moduledoc """
  Bosnia and Herzegovina IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BA",
      ...>    check_digits: "39",
      ...>    bank_code: "129",
      ...>    branch_code: "007",
      ...>    national_check: "94",
      ...>    account_number: "94010284"
      ...>  }
      ...>  |> IbanEx.Country.BA.to_string()
      "BA 39 129 007 94010284 94"
  ```
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{8})(?<national_check>[0-9]{2})$/i

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
