defmodule IbanEx.Country.CZ do
  @moduledoc """
  Czech Republic IBAN parsing rules
  """

  @size 24
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{16})$/i

  use IbanEx.Country.Template
end
