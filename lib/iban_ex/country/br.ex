defmodule IbanEx.Country.BR do
  @moduledoc """
  Brazil IBAN parsing rules

  According to SWIFT registry, Brazil BBAN structure is:
  - Bank code: 8 digits
  - Branch code: 5 digits
  - Account code: 12 characters (10n + 1a + 1c) - account number + account type + owner type

  BBAN spec: 8!n5!n10!n1!a1!c (total 25 chars)
  Example: BR1800360305000010009795493C1
  - Bank: 00360305
  - Branch: 00001
  - Account: 0009795493C1 (includes account number + type + owner)

  ## Examples

  ```elixir
      iex>  %IbanEx.Iban{
      ...>    country_code: "BR",
      ...>    check_digits: "18",
      ...>    bank_code: "00360305",
      ...>    branch_code: "00001",
      ...>    account_number: "0009795493C1",
      ...>    national_check: nil
      ...>  }
      ...>  |> IbanEx.Country.BR.to_string()
      "BR 18 00360305 00001 0009795493C1"
  ```
  """

  @size 29
  @rule ~r/^(?<bank_code>[0-9]{8})(?<branch_code>[0-9]{5})(?<account_number>[0-9]{10}[A-Z]{1}[0-9A-Z]{1})$/i

  use IbanEx.Country.Template

  def rules() do
    [
      bank_code: %{regex: ~r/[0-9]{8}/i, range: 0..7},
      branch_code: %{regex: ~r/[0-9]{5}/i, range: 8..12},
      account_number: %{regex: ~r/[0-9]{10}[A-Z]{1}[0-9A-Z]{1}/i, range: 13..24}
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
    |> Enum.reject(&is_nil/1)
    |> Enum.join(joiner)
  end
end
