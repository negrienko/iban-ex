defmodule IbanEx.Validator do
  @moduledoc false

  alias IbanEx.{Country, Parser}
  alias IbanEx.Validator.Replacements
  import IbanEx.Commons, only: [normalize: 1]

  defp error_accumulator(acc, error_message)
  defp error_accumulator(acc, {:error, error}), do: [error | acc]
  defp error_accumulator(acc, _), do: acc

  defp violation_functions(),
    do: [
      {&__MODULE__.iban_violates_format?/1, {:error, :invalid_format}},
      {&__MODULE__.iban_unsupported_country?/1, {:error, :unsupported_country_code}},
      {&__MODULE__.iban_violates_length?/1, {:error, :invalid_length}},
      {&__MODULE__.iban_violates_country_rule?/1, {:error, :invalid_format_for_country}},
      {&__MODULE__.iban_violates_checksum?/1, {:error, :invalid_checksum}}
    ]

  @doc """
  Accumulate check results in the list of errors
  Check iban_violates_format?, iban_unsupported_country?, iban_violates_length?, iban_violates_country_rule?, iban_violates_checksum?
  """
  @spec violations(String.t()) :: [] | [atom()]
  def violations(iban) do
    violation_functions()
    |> Enum.reduce([], fn {fun, value}, acc -> error_accumulator(acc, !fun.(iban) or value) end)
    |> Enum.reverse()
  end

  @doc """
  Make checks in this order step-by-step before first error ->

    iban_violates_format?,
    iban_unsupported_country?,
    iban_violates_length?,
    iban_violates_country_rule?,
    iban_violates_checksum?

  """
  @type iban() :: binary()
  @type iban_or_error() ::
          {:ok, iban()}
          | {:invalid_checksum, binary()}
          | {:invalid_format, binary()}
          | {:invalid_length, binary()}
          | {:unsupported_country_code, binary()}
  @spec validate(String.t()) :: {:ok, String.t()} | {:error, atom()}

  def validate(iban) do
    cond do
      iban_violates_format?(iban) -> {:error, :invalid_format}
      iban_unsupported_country?(iban) -> {:error, :unsupported_country_code}
      iban_violates_length?(iban) -> {:error, :invalid_length}
      iban_violates_country_rule?(iban) -> {:error, :invalid_format_for_country}
      iban_violates_checksum?(iban) -> {:error, :invalid_checksum}
      true -> {:ok, normalize(iban)}
    end
  end

  @spec size(String.t()) :: non_neg_integer()
  defp size(iban) do
    iban
    |> normalize()
    |> String.length()
  end

  # - Check whether a given IBAN violates the required format.
  @spec iban_violates_format?(String.t()) :: boolean
  def iban_violates_format?(iban),
    do: Regex.match?(~r/[^A-Z0-9]/i, normalize(iban))

  # - Check whether a given IBAN violates the supported countries.
  @spec iban_unsupported_country?(String.t()) :: boolean
  def iban_unsupported_country?(iban) do
    supported? =
      iban
      |> Parser.country_code()
      |> Country.is_country_code_supported?()

    !supported?
  end

  @doc "Check whether a given IBAN violates the required length."
  @spec iban_violates_length?(String.t()) :: boolean
  def iban_violates_length?(iban) do
    with country_code <- Parser.country_code(iban),
         country_module when is_atom(country_module) <- Country.country_module(country_code) do
      size(iban) != country_module.size()
    else
      {:error, _error} -> true
    end
  end

  @doc "Check length of IBAN"
  @spec check_iban_length(String.t()) :: {:error, :length_to_short | :length_to_long} | :ok
  def check_iban_length(iban) do
    case iban_unsupported_country?(iban) do
      true ->
        {:error, :unsupported_country_code}

      false ->
        country_module =
          iban
          |> Parser.country_code()
          |> Country.country_module()

        case country_module.size() - size(iban) do
          diff when diff > 0 -> {:error, :length_to_short}
          diff when diff < 0 -> {:error, :length_to_long}
          0 -> :ok
        end
    end
  end

  @doc "Check whether a given IBAN violates the country rules"
  @spec iban_violates_country_rule?(String.t()) :: boolean
  def iban_violates_country_rule?(iban) do
    with country_code <- Parser.country_code(iban),
         bban <- Parser.bban(iban),
         country_module when is_atom(country_module) <- Country.country_module(country_code),
         rule <- country_module.rule() do
      !Regex.match?(rule, bban)
    else
      _ -> true
    end
  end

  @doc "Check whether a given IBAN violates the required checksum."
  @spec iban_violates_checksum?(String.t()) :: boolean
  def iban_violates_checksum?(iban) do
    check_sum_base = Parser.bban(iban) <> Parser.country_code(iban) <> "00"

    replacements = Replacements.replacements()

    remainder =
      for(<<c <- check_sum_base>>, into: "", do: replacements[<<c>>] || <<c>>)
      |> String.to_integer()
      |> rem(97)

    checksum =
      (98 - remainder)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    checksum !== Parser.check_digits(iban)
  end
end
