defmodule IbanEx.Country.DE do
  @moduledoc """
  Germany IBAN parsing rules
  """

  @size 22
  @rule ~r/^(?<bank_code>[0-9]{8})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
