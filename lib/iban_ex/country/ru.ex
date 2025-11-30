defmodule IbanEx.Country.RU do
  @moduledoc """
  Russia IBAN parsing rules

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "RU",
      ...>    check_digits: "03",
      ...>    bank_code: "044525225",
      ...>    branch_code: "40817",
      ...>    national_check: nil,
      ...>    account_number: "810538091310419"
      ...>  }
      ...>  |> IbanEx.Country.RU.to_string()
      "RU 03 044525225 40817 810538091310419"
  ```
  """

  @size 33
  @rule ~r/^(?<bank_code>[0-9]{9})(?<branch_code>[0-9]{5})(?<account_number>[A-Z0-9]{15})$/i

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
