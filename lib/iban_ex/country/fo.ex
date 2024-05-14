defmodule IbanEx.Country.FO do
  @moduledoc """
  Faroe Islands IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "FO",
      ...>    check_digits: "62",
      ...>    bank_code: "6460",
      ...>    branch_code: nil,
      ...>    national_check: "4",
      ...>    account_number: "000163163"
      ...>  }
      ...>  |> IbanEx.Country.FO.to_string()
      "FO 62 6460 000163163 4"
  ```
  """

  @size 18
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{9})(?<national_check>[0-9]{1})$/i

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
