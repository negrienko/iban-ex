defmodule IbanEx.Country.TR do
  @moduledoc """
  Turkey IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "TR",
      ...>    check_digits: "33",
      ...>    bank_code: "00061",
      ...>    branch_code: nil,
      ...>    national_check: "0",
      ...>    account_number: "0519786457841326"
      ...>  }
      ...>  |> IbanEx.Country.TR.to_string()
      "TR 33 00061 0 0519786457841326"
  ```
  """

  @size 26
  @rule ~r/^(?<bank_code>[A-Z0-9]{5})(?<national_check>[0-9]{1})(?<account_number>[0-9]{16})$/i

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
    [country_code, check_digits, bank_code, national_check, account_number]
    |> Enum.join(joiner)
  end
end
