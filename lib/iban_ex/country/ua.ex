defmodule IbanEx.Country.UA do
  @moduledoc """
  Ukrainian IBAN parsing rules
  """

  @size 29
  @rule ~r/^(?<bank_code>[0-9]{6})(?<account_number>[0-9A-Z]{19})$/i

  use IbanEx.Country.Template
end
