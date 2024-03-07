defmodule IbanEx.Country.NL do
  @moduledoc """
  Netherlands IBAN parsing rules
  """

  @size 18
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
