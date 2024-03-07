defmodule IbanEx.Country.LT do
  @moduledoc """
  Lithuanian IBAN parsing rules
  """

  @size 20
  @rule ~r/^(?<bank_code>[0-9]{5})(?<account_number>[0-9]{11})$/i

  use IbanEx.Country.Template
end
