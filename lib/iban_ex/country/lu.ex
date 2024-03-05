defmodule IbanEx.Country.LU do
  @moduledoc """
  Luxembourg IBAN parsing rules
  """

  alias IbanEx.Iban

  @behaviour IbanEx.Country.Template

  @size 20

  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9A-Z]{13})$/i

  @spec size() :: 20
  def size(), do: @size

  @spec rule() :: Regex.t()
  def rule(), do: @rule

  @spec to_s(Iban.t()) :: binary()
  @spec to_s(Iban.t(), binary()) :: binary()
  def to_s(
        %Iban{
          country_code: country_code,
          check_digits: check_digits,
          bank_code: bank_code,
          branch_code: _branch_code,
          national_check: _national_check,
          account_number: account_number
        } = _iban,
        joiner \\ " "
      ) do
    [country_code, check_digits, bank_code, account_number]
    |> Enum.join(joiner)
  end
end
