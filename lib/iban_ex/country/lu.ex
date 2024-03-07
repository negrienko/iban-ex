defmodule IbanEx.Country.LU do
  @moduledoc """
  Luxembourg IBAN parsing rules
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{3})(?<account_number>[0-9A-Z]{13})$/i

  use IbanEx.Country.Template
end
