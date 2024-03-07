defmodule IbanEx.Country.CH do
  @moduledoc """
  Switzerland IBAN parsing rules
  """

  @size 21
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9A-Z]{12})$/i

  use IbanEx.Country.Template
end
