defmodule IbanEx.Country.MT do
  @moduledoc """
  Malta IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "MT",
      ...>    check_digits: "84",
      ...>    bank_code: "MALT",
      ...>    branch_code: "01100",
      ...>    national_check: nil,
      ...>    account_number: "0012345MTLCAST001S"
      ...>  }
      ...>  |> IbanEx.Country.MT.to_string()
      "MT 84 MALT 01100 0012345MTLCAST001S"
  ```
  """

  @size 31
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{18})$/i

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
