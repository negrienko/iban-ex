defmodule IbanEx.Country.GR do
  @moduledoc """
  Greece IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "GR",
      ...>    check_digits: "16",
      ...>    bank_code: "011",
      ...>    branch_code: "0125",
      ...>    national_check: nil,
      ...>    account_number: "0000000012300695"
      ...>  }
      ...>  |> IbanEx.Country.GR.to_string()
      "GR 16 011 0125 0000000012300695"
  ```
  """

  @size 27
  @rule ~r/^(?<bank_code>[0-9]{3})(?<branch_code>[0-9]{4})(?<account_number>[0-9A-Z]{16})$/i

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
          national_check: _national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
