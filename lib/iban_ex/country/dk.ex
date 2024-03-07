defmodule IbanEx.Country.DK do
  @moduledoc """
  Denmark IBAN parsing rules
  """
  @size 18
  @rule ~r/^(?<bank_code>[0-9]{4})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
