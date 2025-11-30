defmodule IbanEx.Country.MU do
  @moduledoc """
  Mauritius IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MU",
      ...>    check_digits: "17",
      ...>    bank_code: "BOMM01",
      ...>    branch_code: "01",
      ...>    account_number: "101030300200000MUR"
      ...>  }
      ...>  |> IbanEx.Country.MU.to_string()
      "MU 17 BOMM01 01 101030300200000MUR"
  ```
  """

  @size 30
  @rule ~r/^(?<bank_code>[A-Z]{4}[0-9]{2})(?<branch_code>[0-9]{2})(?<account_number>[0-9]{12}[0-9]{3}[A-Z]{3})$/i

  use IbanEx.Country.Template

  def rules() do
    [
      bank_code: %{regex: ~r/[A-Z0-9]{6}/i, range: 0..5},
      branch_code: %{regex: ~r/[0-9]{2}/i, range: 6..7},
      account_number: %{regex: ~r/[0-9A-Z]{18}/i, range: 8..25}
    ]
  end

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
