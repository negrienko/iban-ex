defmodule IbanEx.Country.TN do
  @moduledoc """
  Tunisia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "TN",
      ...>    check_digits: "59",
      ...>    bank_code: "10",
      ...>    branch_code: "006",
      ...>    account_number: "0351835984788",
      ...>    national_check: "31"
      ...>  }
      ...>  |> IbanEx.Country.TN.to_string()
      "TN 59 10 006 0351835984788 31"
  ```
  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{2})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{13})(?<national_check>[0-9]{2})$/i

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
