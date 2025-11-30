defmodule IbanEx.IbanFactory do
  @moduledoc """
  Factory for creating IBAN test fixtures with various attributes.
  Supports creating valid and invalid IBANs for comprehensive testing.
  """

  alias IbanEx.{Iban, Country}

  @doc """
  Build an IBAN struct with custom attributes.

  ## Options
  - `:country_code` - Two-letter country code (default: "DE")
  - `:check_digits` - Two-digit check code (default: auto-calculated)
  - `:bank_code` - Bank identifier code
  - `:branch_code` - Branch identifier code
  - `:account_number` - Account number
  - `:national_check` - National check digit(s)
  - `:iban` - Full IBAN string (overrides other options)

  ## Examples

      iex> IbanEx.IbanFactory.build(country_code: "DE")
      %IbanEx.Iban{country_code: "DE", ...}

      iex> IbanEx.IbanFactory.build(iban: "DE89370400440532013000")
      %IbanEx.Iban{country_code: "DE", check_code: "89", ...}
  """
  def build(attrs \\ []) do
    if iban_string = Keyword.get(attrs, :iban) do
      build_from_string(iban_string)
    else
      build_from_attrs(attrs)
    end
  end

  @doc """
  Build an IBAN with an invalid checksum.

  ## Examples

      iex> iban = IbanEx.IbanFactory.build_with_invalid_checksum(country_code: "DE")
      iex> IbanEx.Validator.valid?(iban.iban)
      false
  """
  def build_with_invalid_checksum(attrs \\ []) do
    iban = build(attrs)

    # Flip the last digit of check code to make it invalid
    current_check = iban.check_code
    invalid_check = flip_last_digit(current_check)

    invalid_iban =
      String.replace(iban.iban, ~r/^[A-Z]{2}\d{2}/, "#{iban.country_code}#{invalid_check}")

    %{iban | iban: invalid_iban, check_code: invalid_check}
  end

  @doc """
  Build an IBAN with invalid length (too short).
  """
  def build_with_invalid_length_short(attrs \\ []) do
    iban = build(attrs)
    invalid_iban = String.slice(iban.iban, 0..-2//1)

    %{iban | iban: invalid_iban}
  end

  @doc """
  Build an IBAN with invalid length (too long).
  """
  def build_with_invalid_length_long(attrs \\ []) do
    iban = build(attrs)
    invalid_iban = iban.iban <> "0"

    %{iban | iban: invalid_iban}
  end

  @doc """
  Build an IBAN with invalid characters in BBAN.
  """
  def build_with_invalid_characters(attrs \\ []) do
    iban = build(attrs)

    # Replace a digit in the BBAN with an invalid character
    bban_start = 4
    iban_chars = String.graphemes(iban.iban)

    invalid_chars =
      List.replace_at(iban_chars, bban_start + 2, "Ї")
      |> Enum.join()

    %{iban | iban: invalid_chars}
  end

  @doc """
  Build an IBAN with unsupported country code.
  """
  def build_with_unsupported_country do
    # Return the IBAN string directly since XX is not supported
    "XX89370400440532013000"
  end

  # Private functions

  defp build_from_string(iban_string) do
    case IbanEx.parse(iban_string) do
      {:ok, iban} -> iban
      {:error, _} -> raise "Invalid IBAN string: #{iban_string}"
    end
  end

  defp build_from_attrs(attrs) do
    country_code = Keyword.get(attrs, :country_code, "DE")

    # Get a valid example IBAN for this country
    example_iban = get_example_iban(country_code)

    # Parse it to get the structure
    {:ok, base_iban} = IbanEx.parse(example_iban)

    # Override with provided attributes
    %{
      base_iban
      | bank_code: Keyword.get(attrs, :bank_code, base_iban.bank_code),
        branch_code: Keyword.get(attrs, :branch_code, base_iban.branch_code),
        account_number: Keyword.get(attrs, :account_number, base_iban.account_number),
        national_check: Keyword.get(attrs, :national_check, base_iban.national_check)
    }
    |> rebuild_iban()
  end

  defp get_example_iban(country_code) do
    # Use the test fixtures to get a valid example
    fixtures_path =
      Path.join([
        __DIR__,
        "..",
        "..",
        "docs",
        "international_wide_ibans",
        "iban_test_fixtures.json"
      ])

    fixtures =
      fixtures_path
      |> File.read!()
      |> JSON.decode!()

    fixtures["valid_ibans"][country_code]["electronic"]
  end

  defp rebuild_iban(iban) do
    # Reconstruct the BBAN from components
    bban_parts =
      [
        iban.bank_code,
        iban.branch_code,
        iban.account_number,
        iban.national_check
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.join()

    # Calculate the check digits
    check_digits = calculate_check_digits(iban.country_code, bban_parts)

    iban_string = "#{iban.country_code}#{check_digits}#{bban_parts}"

    %{iban | iban: iban_string, check_code: check_digits}
  end

  defp calculate_check_digits(country_code, bban) do
    # Move country code and "00" to end, then mod 97
    rearranged = bban <> country_code <> "00"

    # Replace letters with numbers (A=10, B=11, ..., Z=35)
    numeric =
      rearranged
      |> String.graphemes()
      |> Enum.map(fn char ->
        if char =~ ~r/[A-Z]/ do
          [char_code] = String.to_charlist(char)
          Integer.to_string(char_code - 55)
        else
          char
        end
      end)
      |> Enum.join()

    # Calculate mod 97
    remainder =
      numeric
      |> String.to_integer()
      |> rem(97)

    # Check digit is 98 - remainder
    check = 98 - remainder

    check
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  defp flip_last_digit(check_code) do
    last_digit = String.last(check_code)
    flipped = if last_digit == "0", do: "1", else: "0"
    String.slice(check_code, 0..-2//1) <> flipped
  end
end
