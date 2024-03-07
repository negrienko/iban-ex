defmodule IbanEx.Country.LV do
  @moduledoc """
  Latvian IBAN parsing rules
  """

  @size 21
  @rule ~r/^(?<bank_code>[A-Z]{4})(?<account_number>[0-9A-Z]{13})$/i

  use IbanEx.Country.Template
end
