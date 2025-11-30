defmodule IbanEx.Country.YE do
  @moduledoc """
  Yemen IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "YE",
      ...>    check_digits: "15",
      ...>    bank_code: "CBYE",
      ...>    branch_code: "0001",
      ...>    account_number: "018861234567891234"
      ...>  }
      ...>  |> IbanEx.Country.YE.to_string()
      "YE 15 CBYE 0001 018861234567891234"
  ```
  """

  @size 30
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{4})(?<account_number>[A-Z0-9]{18})$/i

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
