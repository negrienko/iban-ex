defmodule IbanEx.Country.HN do
  @moduledoc """
  Honduras IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "HN",
      ...>    check_digits: "88",
      ...>    bank_code: "CABF",
      ...>    account_number: "00000000000250005469"
      ...>  }
      ...>  |> IbanEx.Country.HN.to_string()
      "HN 88 CABF 00000000000250005469"
  ```
  """

  @size 28
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{20})$/i

  use IbanEx.Country.Template

  @impl IbanEx.Country.Template
  @spec to_string(Iban.t()) :: binary()
  @spec to_string(Iban.t(), binary()) :: binary()
  def to_string(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, account_number]
    |> Enum.join(joiner)
  end
end
