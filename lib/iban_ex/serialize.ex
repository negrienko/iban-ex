defmodule IbanEx.Serialize do
  @moduledoc false

  alias IbanEx.{Iban, Formatter}

  @spec to_string(Iban.t()) :: String.t()
  def to_string(iban), do: Formatter.format(iban)

  @spec to_map(Iban.t()) :: Map.t()
  def to_map(iban), do: Map.from_struct(iban)
end
