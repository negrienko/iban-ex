defmodule IbanEx.Country.HR do
  @moduledoc """
  Croatia IBAN parsing rules
  """

  @size 21
  @rule ~r/^(?<bank_code>[0-9]{7})(?<account_number>[0-9]{10})$/i

  use IbanEx.Country.Template
end
