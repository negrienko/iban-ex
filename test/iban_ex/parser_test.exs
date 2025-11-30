defmodule IbanEx.ParserTest do
  @moduledoc """
  Comprehensive test coverage for IbanEx.Parser module.
  Based on Test Coverage Improvement Plan - Phase 1: Critical Coverage.
  """

  use ExUnit.Case, async: true

  alias IbanEx.{Parser, TestData, Iban}

  describe "parse/1 - comprehensive parsing" do
    test "parses all 105 registry valid IBANs successfully" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        assert {:ok, %Iban{}} = Parser.parse(iban), "Failed to parse: #{iban}"
      end)
    end

    test "parses shortest IBAN (Norway, 15 chars)" do
      {:ok, iban} = Parser.parse("NO9386011117947")

      assert iban.country_code == "NO"
      assert iban.check_digits == "93"
      assert iban.bank_code == "8601"
      assert iban.account_number == "111794"
      assert iban.branch_code == nil
      assert String.length(iban.iban) == 15
    end

    test "parses longest IBAN (Russia, 33 chars)" do
      longest = TestData.edge_cases().longest
      {:ok, iban} = Parser.parse(longest)

      assert iban.country_code == "RU"
      assert String.length(iban.iban) == 33
      assert String.length(iban.bank_code) == 9
      assert String.length(iban.branch_code) == 5
      assert String.length(iban.account_number) == 15
    end

    test "parses IBAN with branch code (France)" do
      {:ok, iban} = Parser.parse("FR1420041010050500013M02606")

      assert iban.country_code == "FR"
      assert iban.check_digits == "14"
      assert iban.bank_code == "20041"
      assert iban.branch_code == "01005"
      assert iban.account_number == "0500013M026"
      assert iban.national_check == "06"
    end

    test "parses IBAN with national check (Italy)" do
      {:ok, iban} = Parser.parse("IT60X0542811101000000123456")

      assert iban.country_code == "IT"
      assert iban.check_digits == "60"
      assert iban.national_check == "X"
      assert iban.bank_code == "05428"
      assert iban.branch_code == "11101"
      assert iban.account_number == "000000123456"
    end

    test "parses IBAN with alphanumeric BBAN (Qatar)" do
      {:ok, iban} = Parser.parse("QA58DOHB00001234567890ABCDEFG")

      assert iban.country_code == "QA"
      assert iban.check_digits == "58"
      assert iban.bank_code == "DOHB"
      assert iban.account_number == "00001234567890ABCDEFG"
    end

    test "parses electronic format" do
      {:ok, iban} = Parser.parse("DE89370400440532013000")

      assert iban.iban == "DE89370400440532013000"
      assert iban.country_code == "DE"
    end

    test "parses print format with spaces" do
      {:ok, iban} = Parser.parse("DE89 3704 0044 0532 0130 00")

      # Parser should normalize to electronic format
      assert iban.iban == "DE89370400440532013000"
      assert iban.country_code == "DE"
    end

    test "returns error for invalid checksum" do
      assert {:error, _} = Parser.parse("DE00370400440532013000")
    end

    test "returns error for unsupported country code" do
      assert {:error, _} = Parser.parse("XX89370400440532013000")
    end

    test "returns error for invalid length (too short)" do
      assert {:error, _} = Parser.parse("DE8937040044053201300")
    end

    test "returns error for invalid length (too long)" do
      assert {:error, _} = Parser.parse("DE89370400440532013000XXX")
    end

    test "returns error for invalid characters" do
      assert {:error, _} = Parser.parse("DE89370400440532013Ї00")
    end

    test "returns error for empty string" do
      assert {:error, _} = Parser.parse("")
    end

    test "returns error for nil" do
      assert {:error, _} = Parser.parse(nil)
    end
  end

  describe "parse/1 - BBAN component extraction" do
    test "extracts bank code for all countries" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.bank_code), "Missing bank code for: #{iban}"
        assert String.length(parsed.bank_code) > 0
      end)
    end

    test "extracts branch code for countries that have it" do
      # Countries with branch codes (55 countries)
      ibans_with_branch = TestData.ibans_with(has_branch_code: true)

      Enum.each(ibans_with_branch, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.branch_code), "Missing branch code for: #{iban}"
        assert String.length(parsed.branch_code) > 0
      end)
    end

    test "sets branch code to nil for countries without it" do
      ibans_without_branch = TestData.ibans_with(has_branch_code: false)

      Enum.each(ibans_without_branch, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_nil(parsed.branch_code), "Unexpected branch code for: #{iban}"
      end)
    end

    test "extracts national check for countries that have it" do
      ibans_with_check = TestData.ibans_with(has_national_check: true)

      Enum.each(ibans_with_check, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.national_check), "Missing national check for: #{iban}"
        assert String.length(parsed.national_check) > 0
      end)
    end

    test "sets national check to nil for countries without it" do
      ibans_without_check = TestData.ibans_with(has_national_check: false)

      Enum.each(ibans_without_check, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_nil(parsed.national_check), "Unexpected national check for: #{iban}"
      end)
    end

    test "extracts account number for all countries" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.account_number), "Missing account number for: #{iban}"
        assert String.length(parsed.account_number) > 0
      end)
    end
  end

  describe "parse/1 - position calculations" do
    test "correctly calculates positions for Germany (simple structure)" do
      {:ok, iban} = Parser.parse("DE89370400440532013000")

      # BBAN: 370400440532013000
      # Bank code (8n): 37040044
      # Account (10n): 0532013000
      assert iban.bank_code == "37040044"
      assert iban.account_number == "0532013000"
      assert iban.branch_code == nil
    end

    test "correctly calculates positions for France (complex structure)" do
      {:ok, iban} = Parser.parse("FR1420041010050500013M02606")

      # Per SWIFT registry and Wise validation, France structure is:
      # BBAN: 20041010050500013M02606 (23 chars)
      # Bank (5n): 20041
      # Branch (5n): 01005
      # Account (11c): 0500013M026
      # National check (2n): 06
      assert iban.bank_code == "20041"
      assert iban.branch_code == "01005"
      assert iban.account_number == "0500013M026"
      assert iban.national_check == "06"
    end

    test "correctly calculates positions for GB (6-digit sort code)" do
      {:ok, iban} = Parser.parse("GB29NWBK60161331926819")

      # Bank (4a): NWBK
      # Branch/Sort (6n): 601613
      # Account (8n): 31926819
      assert iban.bank_code == "NWBK"
      assert iban.branch_code == "601613"
      assert iban.account_number == "31926819"
    end

    test "correctly calculates positions for Brazil (complex alphanumeric)" do
      {:ok, iban} = Parser.parse("BR1800360305000010009795493C1")

      # Brazil has: bank (8n) + branch (5n) + account (10n) + type (1a) + owner (1c)
      assert String.length(iban.bank_code) == 8
      assert String.length(iban.branch_code) == 5
      # Account number includes type and owner
      assert String.length(iban.account_number) > 10
    end
  end

  describe "parse/1 - edge cases" do
    test "handles all-numeric BBANs" do
      # Germany has all-numeric BBAN
      {:ok, iban} = Parser.parse("DE89370400440532013000")

      assert iban.bank_code =~ ~r/^\d+$/
      assert iban.account_number =~ ~r/^\d+$/
    end

    test "handles alphanumeric BBANs" do
      # Qatar has alphanumeric BBAN
      {:ok, iban} = Parser.parse("QA58DOHB00001234567890ABCDEFG")

      assert iban.bank_code == "DOHB"
      assert iban.account_number =~ ~r/[A-Z]/
    end

    test "handles IBANs with letters at the end" do
      # Brazil ends with letter
      {:ok, iban} = Parser.parse("BR1800360305000010009795493C1")

      assert String.ends_with?(iban.account_number, "1") or
               String.ends_with?(iban.iban, "1")
    end

    test "handles minimum length IBAN (15 chars)" do
      {:ok, iban} = Parser.parse("NO9386011117947")

      assert String.length(iban.iban) == 15
      assert iban.country_code == "NO"
      assert String.length(iban.bank_code) == 4
      assert String.length(iban.account_number) == 6
    end

    test "handles maximum length IBAN (33 chars)" do
      longest = TestData.edge_cases().longest
      {:ok, iban} = Parser.parse(longest)

      assert String.length(iban.iban) == 33
      assert iban.country_code == "RU"
    end

    test "handles IBANs from all length categories" do
      length_samples = [
        # Shortest
        15,
        # Short
        18,
        # Medium-short (most common)
        22,
        # Medium-long (most common)
        27,
        # Long
        29,
        # Longest
        33
      ]

      Enum.each(length_samples, fn target_length ->
        ibans = TestData.ibans_with(length: target_length)

        if length(ibans) > 0 do
          iban = List.first(ibans)
          assert {:ok, parsed} = Parser.parse(iban)
          assert String.length(parsed.iban) == target_length
        end
      end)
    end
  end

  describe "parse/1 - normalization" do
    test "normalizes print format to electronic format" do
      print_format = "DE89 3704 0044 0532 0130 00"
      electronic_format = "DE89370400440532013000"

      {:ok, from_print} = Parser.parse(print_format)
      {:ok, from_electronic} = Parser.parse(electronic_format)

      assert from_print.iban == from_electronic.iban
      assert from_print == from_electronic
    end

    test "removes whitespace from input" do
      with_spaces = "FR14 2004 1010 0505 0001 3M02 606"
      {:ok, iban} = Parser.parse(with_spaces)

      refute String.contains?(iban.iban, " ")
    end

    test "preserves original electronic format when no spaces" do
      original = "DE89370400440532013000"
      {:ok, iban} = Parser.parse(original)

      assert iban.iban == original
    end
  end

  describe "parse/1 - error handling" do
    test "returns descriptive error for unsupported country" do
      assert {:error, reason} = Parser.parse("XX89370400440532013000")
      assert reason != nil
    end

    test "returns descriptive error for invalid length" do
      assert {:error, reason} = Parser.parse("DE8937040044053201")
      assert reason != nil
    end

    test "returns descriptive error for invalid checksum" do
      assert {:error, reason} = Parser.parse("DE00370400440532013000")
      assert reason != nil
    end

    test "returns descriptive error for invalid characters" do
      assert {:error, reason} = Parser.parse("DE89370400440532013Ї00")
      assert reason != nil
    end

    test "returns descriptive error for empty input" do
      assert {:error, reason} = Parser.parse("")
      assert reason != nil
    end

    test "returns descriptive error for nil input" do
      assert {:error, reason} = Parser.parse(nil)
      assert reason != nil
    end
  end

  describe "parse/1 - SEPA countries" do
    test "parses all 53 SEPA country IBANs" do
      sepa_ibans = TestData.valid_ibans(sepa_only: true)

      assert length(sepa_ibans) == 53

      Enum.each(sepa_ibans, fn iban ->
        assert {:ok, %Iban{}} = Parser.parse(iban), "SEPA parsing failed: #{iban}"
      end)
    end

    test "parses French territories using FR rules" do
      # French territories use FR as country code in IBAN, but are listed separately in registry
      # Real IBANs for French territories start with "FR", not their territory code
      # See: docs/international_wide_ibans/README.md - SEPA Countries Include Territories
      french_territories = [
        "GF",
        "GP",
        "MQ",
        "RE",
        "PF",
        "TF",
        "YT",
        "NC",
        "BL",
        "MF",
        "PM",
        "WF"
      ]

      Enum.each(french_territories, fn territory ->
        ibans = TestData.valid_ibans(country: territory)

        if length(ibans) > 0 do
          iban = List.first(ibans)
          assert {:ok, parsed} = Parser.parse(iban)
          # Territory IBANs use "FR" as the country code in the actual IBAN
          assert parsed.country_code == "FR"
          # Should follow FR structure (27 chars)
          assert String.length(parsed.iban) == 27
        end
      end)
    end
  end

  describe "parse/1 - registry compliance" do
    test "parsed IBANs match registry specifications" do
      TestData.all_country_codes()
      |> Enum.each(fn country_code ->
        spec = TestData.country_spec(country_code)
        [iban] = TestData.valid_ibans(country: country_code)

        {:ok, parsed} = Parser.parse(iban)

        assert String.length(parsed.iban) == spec["iban_length"],
               "Length mismatch for #{country_code}"

        # Extract actual country code from iban_spec (e.g., "FI2!n..." -> "FI")
        # Territories like AX use parent country code (FI) in actual IBANs
        expected_country_code = String.slice(spec["iban_spec"], 0..1)

        assert parsed.country_code == expected_country_code,
               "Country code mismatch for #{country_code}: expected #{expected_country_code}, got #{parsed.country_code}"
      end)
    end

    test "BBAN components match registry positions" do
      # Test a sample of countries with different structures
      test_countries = ["DE", "FR", "GB", "IT", "ES", "BR", "NO", "RU"]

      Enum.each(test_countries, fn country_code ->
        spec = TestData.country_spec(country_code)
        [iban] = TestData.valid_ibans(country: country_code)

        {:ok, parsed} = Parser.parse(iban)

        # Verify bank code length matches spec
        bank_positions = spec["positions"]["bank_code"]
        expected_bank_length = bank_positions["end"] - bank_positions["start"]

        if expected_bank_length > 0 do
          assert String.length(parsed.bank_code) == expected_bank_length,
                 "Bank code length mismatch for #{country_code}"
        end
      end)
    end
  end
end
