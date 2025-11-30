defmodule IbanEx.Country.SO do
  @moduledoc """
  Somalia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "SO",
      ...>    check_digits: "21",
      ...>    bank_code: "1000",
      ...>    branch_code: "001",
      ...>    national_check: nil,
      ...>    account_number: "001000100141"
      ...>  }
      ...>  |> IbanEx.Country.SO.to_string()
      "SO 21 1000 001 001000100141"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{12})$/i

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
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, branch_code, account_number]
    |> Enum.join(joiner)
  end
end
