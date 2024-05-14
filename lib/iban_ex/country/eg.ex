defmodule IbanEx.Country.EG do
  @moduledoc """
  Egypt IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "EG",
      ...>    check_digits: "38",
      ...>    bank_code: "0019",
      ...>    branch_code: "0005",
      ...>    national_check: nil,
      ...>    account_number: "00000000263180002"
      ...>  }
      ...>  |> IbanEx.Country.EG.to_string()
      "EG 38 0019 0005 00000000263180002"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[0-9]{4})(?<branch_code>[0-9]{4})(?<account_number>[0-9]{17})$/i

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
