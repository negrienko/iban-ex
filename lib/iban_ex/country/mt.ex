defmodule IbanEx.Country.MT do
  @moduledoc """
  Malta IBAN parsing rules
  """

  alias IbanEx.Iban

  @behaviour IbanEx.Country.Template

  @size 31

  @rule ~r/^(?<bank_code>[A-Z]{4})(?<branch_code>[0-9]{5})(?<account_number>[0-9A-Z]{18})$/i

  @spec size() :: 31
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
