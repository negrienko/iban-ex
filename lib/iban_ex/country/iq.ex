defmodule IbanEx.Country.IQ do
  @moduledoc """
  Iraq IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "IQ",
      ...>    check_digits: "98",
      ...>    bank_code: "NBIQ",
      ...>    branch_code: "850",
      ...>    account_number: "123456789012"
      ...>  }
      ...>  |> IbanEx.Country.IQ.to_string()
      "IQ 98 NBIQ 850 123456789012"
  ```
  """

  @size 23
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{3})(?<account_number>[0-9]{12})$/i

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
