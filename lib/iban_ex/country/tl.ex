defmodule IbanEx.Country.TL do
  @moduledoc """
  Timor-Leste IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "TL",
      ...>    check_digits: "38",
      ...>    bank_code: "008",
      ...>    branch_code: nil,
      ...>    national_check: "57",
      ...>    account_number: "00123456789101"
      ...>  }
      ...>  |> IbanEx.Country.TL.to_string()
      "TL 38 008 00123456789101 57"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9]{14})(?<national_check>[0-9]{2})$/i

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
