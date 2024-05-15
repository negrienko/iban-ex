defmodule IbanEx.Commons do
  @moduledoc false

  @spec blank(nil | binary()) :: nil | binary()
  def blank(nil), do: nil
  def blank(""), do: nil
  def blank(string) when is_binary(string), do: string

  @spec normalize(binary()) :: binary()
  def normalize(string) do
    string
    |> to_string()
    |> String.replace(~r/\s*/i, "")
    |> String.upcase()
  end

  @spec normalize_and_slice(binary(), Range.t()) :: binary()
  def normalize_and_slice(string, range) do
    string
    |> normalize()
    |> String.slice(range)
    # |> case do
    #   "" -> nil
    #   result -> result
    # end
  end
end
