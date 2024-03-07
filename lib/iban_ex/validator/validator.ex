defmodule IbanEx.Validator do
  @moduledoc false

  alias IbanEx.{Country, Parser}
  alias IbanEx.Validator.Replacements
  import IbanEx.Commons, only: [normalize: 1]

  @spec validate(String.t()) :: {:ok, String.t()} | {:error, Atom.t()}
  def validate(iban) do
    cond do
      iban_violates_format?(iban) ->
        {:error, :invalid_format}

      iban_unsupported_country?(iban) ->
        {:error, :unsupported_country_code}

      iban_violates_length?(iban) ->
        {:error, :invalid_length}

      iban_violates_country_rule?(iban) ->
        {:error, :invalid_format}

      iban_violates_checksum?(iban) ->
        {:error, :invalid_checksum}

      true ->
        {:ok, normalize(iban)}
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
  defp iban_violates_format?(iban),
    do: Regex.match?(~r/[^A-Z0-9]/i, normalize(iban))

  # - Check whether a given IBAN violates the supported countries.
  @spec iban_unsupported_country?(String.t()) :: boolean
  defp iban_unsupported_country?(iban) do
    supported? =
      iban
      |> Parser.country_code()
      |> Country.is_country_code_supported?()

    !supported?
  end

  # - Check whether a given IBAN violates the required length.
  @spec iban_violates_length?(String.t()) :: boolean
  defp iban_violates_length?(iban) do
    with country_code <- Parser.country_code(iban),
         country_module <- Country.country_module(country_code) do
      size(iban) != country_module.size()
    else
      {:error, _} -> true
    end
  end

  # - Check whether a given IBAN violates the country rules.
  @spec iban_violates_country_rule?(String.t()) :: boolean
  defp iban_violates_country_rule?(iban) do
    with country_code <- Parser.country_code(iban),
         bban <- Parser.bban(iban),
         country_module <- Country.country_module(country_code),
         rule <- country_module.rule() do
      !Regex.match?(rule, bban)
    else
      {:error, _} -> true
    end
  end

  # - Check whether a given IBAN violates the required checksum.
  @spec iban_violates_checksum?(String.t()) :: boolean
  defp iban_violates_checksum?(iban) do
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
