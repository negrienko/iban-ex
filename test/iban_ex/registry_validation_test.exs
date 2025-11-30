defmodule IbanEx.RegistryValidationTest do
  @moduledoc """
  Comprehensive registry validation tests for IbanEx.

  Validates IbanEx implementation against the official SWIFT IBAN Registry Release 100.
  Ensures all 105 countries/territories are correctly supported with proper:
  - IBAN lengths
  - BBAN structures
  - Component positions
  - SEPA classifications
  - Check digit validation

  Based on Test Coverage Improvement Plan and IBAN Registry Summary.
  """

  use ExUnit.Case, async: true

  alias IbanEx.{Validator, Parser, Country, TestData}

  describe "Registry coverage - all 105 countries" do
    test "validates all 105 registry IBANs successfully" do
      valid_ibans = TestData.valid_ibans()

      assert length(valid_ibans) == 105,
             "Expected 105 IBANs from registry, got #{length(valid_ibans)}"

      Enum.each(valid_ibans, fn iban ->
        assert TestData.valid?(iban),
               "Registry IBAN validation failed: #{iban}"
      end)
    end

    test "parses all 105 registry IBANs successfully" do
      valid_ibans = TestData.valid_ibans()

      Enum.each(valid_ibans, fn iban ->
        assert {:ok, _parsed} = Parser.parse(iban),
               "Registry IBAN parsing failed: #{iban}"
      end)
    end

    test "all registry country codes are supported" do
      registry_codes = TestData.all_country_codes()
      supported_codes = Country.supported_country_codes() |> Enum.sort()

      registry_set = MapSet.new(registry_codes)
      supported_set = MapSet.new(supported_codes)

      missing = MapSet.difference(registry_set, supported_set) |> MapSet.to_list()
      extra = MapSet.difference(supported_set, registry_set) |> MapSet.to_list()

      assert missing == [], "Missing country codes: #{inspect(missing)}"
      assert extra == [], "Extra unsupported codes: #{inspect(extra)}"
      assert length(registry_codes) == length(supported_codes)
    end
  end

  describe "IBAN length validation - 18 unique lengths (15-33)" do
    test "validates shortest IBAN (Norway, 15 chars)" do
      shortest = TestData.edge_cases().shortest

      assert String.length(shortest) == 15
      assert TestData.valid?(shortest)
      assert shortest =~ ~r/^NO\d{13}$/
    end

    test "validates longest IBAN (Russia, 33 chars)" do
      longest = TestData.edge_cases().longest

      assert String.length(longest) == 33
      assert TestData.valid?(longest)
      assert longest =~ ~r/^RU\d{31}$/
    end

    test "validates all unique IBAN lengths from registry" do
      # Registry has 18 unique lengths: 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33
      fixtures = TestData.load_fixtures()

      lengths_in_registry =
        fixtures["country_specs"]
        |> Map.values()
        |> Enum.map(fn spec -> spec["iban_length"] end)
        |> Enum.uniq()
        |> Enum.sort()

      assert 15 in lengths_in_registry
      assert 33 in lengths_in_registry
      assert length(lengths_in_registry) >= 18

      # Validate at least one IBAN for each length
      Enum.each(lengths_in_registry, fn target_length ->
        ibans = TestData.ibans_with(length: target_length)
        assert length(ibans) > 0, "No IBANs found for length #{target_length}"

        iban = List.first(ibans)
        assert String.length(iban) == target_length
        assert TestData.valid?(iban)
      end)
    end

    test "country module sizes match registry lengths" do
      TestData.all_country_codes()
      |> Enum.each(fn country_code ->
        spec = TestData.country_spec(country_code)
        expected_length = spec["iban_length"]

        country_module = Country.country_module(country_code)
        actual_length = country_module.size()

        assert actual_length == expected_length,
               "Length mismatch for #{country_code}: expected #{expected_length}, got #{actual_length}"
      end)
    end
  end

  describe "BBAN structure validation" do
    test "all countries have bank codes (100% coverage)" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        {:ok, parsed} = Parser.parse(iban)

        assert is_binary(parsed.bank_code),
               "Missing bank code for: #{iban}"

        assert String.length(parsed.bank_code) > 0,
               "Empty bank code for: #{iban}"
      end)
    end

    test "55 countries have branch codes" do
      ibans_with_branch = TestData.ibans_with(has_branch_code: true)

      # Registry indicates 52% (55 countries) have branch codes
      assert length(ibans_with_branch) >= 50,
             "Expected ~55 countries with branch codes, got #{length(ibans_with_branch)}"

      Enum.each(ibans_with_branch, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.branch_code)
        assert String.length(parsed.branch_code) > 0
      end)
    end

    test "13 countries have national check digits" do
      ibans_with_check = TestData.ibans_with(has_national_check: true)

      # Registry indicates 12% (13 countries) have national check digits
      assert length(ibans_with_check) >= 10,
             "Expected ~13 countries with national check, got #{length(ibans_with_check)}"

      Enum.each(ibans_with_check, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        assert is_binary(parsed.national_check)
        assert String.length(parsed.national_check) > 0
      end)
    end

    test "all countries have account numbers (100% coverage)" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        {:ok, parsed} = Parser.parse(iban)

        assert is_binary(parsed.account_number),
               "Missing account number for: #{iban}"

        assert String.length(parsed.account_number) > 0,
               "Empty account number for: #{iban}"
      end)
    end
  end

  describe "Character type distribution" do
    test "validates numeric-only BBANs (68 countries, 64.8%)" do
      numeric_ibans = TestData.ibans_with(numeric_only: true)

      assert length(numeric_ibans) >= 65,
             "Expected ~68 numeric-only countries, got #{length(numeric_ibans)}"

      # Verify they are actually numeric
      Enum.each(numeric_ibans, fn iban ->
        {:ok, parsed} = Parser.parse(iban)
        bban = String.slice(iban, 4..-1//1)

        assert bban =~ ~r/^\d+$/,
               "Expected numeric BBAN for #{parsed.country_code}, got: #{bban}"
      end)
    end

    test "validates alphanumeric BBANs (31+ countries, 29.5%)" do
      alphanumeric_ibans = TestData.ibans_with(numeric_only: false)

      assert length(alphanumeric_ibans) >= 30,
             "Expected ~31 alphanumeric countries, got #{length(alphanumeric_ibans)}"

      # Verify they contain letters
      Enum.each(alphanumeric_ibans, fn iban ->
        bban = String.slice(iban, 4..-1//1)

        assert bban =~ ~r/[A-Z]/,
               "Expected alphanumeric BBAN for #{iban}, got: #{bban}"
      end)
    end

    test "validates specific alphanumeric examples from registry" do
      # Bahrain: 4!a14!c pattern
      {:ok, bh} = Parser.parse("BH67BMAG00001299123456")
      assert bh.bank_code == "BMAG"
      assert bh.bank_code =~ ~r/^[A-Z]{4}$/

      # Qatar: 4!a21!c pattern
      {:ok, qa} = Parser.parse("QA58DOHB00001234567890ABCDEFG")
      assert qa.bank_code == "DOHB"
      assert qa.account_number =~ ~r/[A-Z]/
    end
  end

  describe "SEPA country validation (53 countries)" do
    test "validates all 53 SEPA country IBANs" do
      sepa_ibans = TestData.valid_ibans(sepa_only: true)

      assert length(sepa_ibans) == 53,
             "Expected 53 SEPA IBANs, got #{length(sepa_ibans)}"

      Enum.each(sepa_ibans, fn iban ->
        assert TestData.valid?(iban),
               "SEPA IBAN validation failed: #{iban}"
      end)
    end

    test "validates major SEPA countries" do
      major_sepa = %{
        "DE" => "Germany",
        "FR" => "France",
        "GB" => "United Kingdom",
        "IT" => "Italy",
        "ES" => "Spain",
        "NL" => "Netherlands",
        "CH" => "Switzerland",
        "AT" => "Austria",
        "BE" => "Belgium",
        "SE" => "Sweden"
      }

      Enum.each(major_sepa, fn {code, name} ->
        [iban] = TestData.valid_ibans(country: code)

        assert TestData.valid?(iban),
               "Major SEPA country #{name} (#{code}) validation failed"
      end)
    end

    test "validates SEPA territory mappings" do
      # French territories use FR rules
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
          {:ok, parsed} = Parser.parse(iban)

          # Should have same length as France (27 chars)
          assert String.length(iban) == 27,
                 "French territory #{territory} should have 27 chars like France"
        end
      end)

      # British territories
      british_territories = ["IM", "JE", "GG"]

      Enum.each(british_territories, fn territory ->
        ibans = TestData.valid_ibans(country: territory)

        if length(ibans) > 0 do
          iban = List.first(ibans)
          {:ok, parsed} = Parser.parse(iban)

          # Should have same length as GB (22 chars)
          assert String.length(iban) == 22,
                 "British territory #{territory} should have 22 chars like GB"
        end
      end)
    end

    test "SEPA country specs match registry" do
      sepa_codes = TestData.sepa_country_codes()

      assert length(sepa_codes) == 53
      assert "DE" in sepa_codes
      assert "FR" in sepa_codes
      assert "GB" in sepa_codes
    end
  end

  describe "Checksum validation across all countries" do
    test "all 105 registry IBANs have valid checksums" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        violations = Validator.violations(iban)

        refute :invalid_checksum in violations,
               "Invalid checksum for registry IBAN: #{iban}"
      end)
    end

    test "checksum validation works for shortest IBAN" do
      shortest = TestData.edge_cases().shortest
      assert TestData.valid?(shortest)

      # Test with invalid checksum
      invalid = String.replace(shortest, ~r/^NO\d{2}/, "NO00")
      refute TestData.valid?(invalid)
    end

    test "checksum validation works for longest IBAN" do
      longest = TestData.edge_cases().longest
      assert TestData.valid?(longest)

      # Test with invalid checksum
      invalid = String.replace(longest, ~r/^RU\d{2}/, "RU00")
      refute TestData.valid?(invalid)
    end

    test "checksum validation works for alphanumeric BBANs" do
      # Bahrain
      assert TestData.valid?("BH67BMAG00001299123456")
      refute TestData.valid?("BH00BMAG00001299123456")

      # Qatar
      assert TestData.valid?("QA58DOHB00001234567890ABCDEFG")
      refute TestData.valid?("QA00DOHB00001234567890ABCDEFG")
    end
  end

  describe "Component position accuracy" do
    test "Germany - simple numeric structure (8!n10!n)" do
      {:ok, de} = Parser.parse("DE89370400440532013000")

      assert de.bank_code == "37040044"
      assert String.length(de.bank_code) == 8

      assert de.account_number == "0532013000"
      assert String.length(de.account_number) == 10

      assert de.branch_code == nil
      assert de.national_check == nil
    end

    test "France - complex structure with all components (5!n5!n11!c2!n)" do
      {:ok, fr} = Parser.parse("FR1420041010050500013M02606")

      assert fr.bank_code == "20041"
      assert String.length(fr.bank_code) == 5

      assert fr.branch_code == "01005"
      assert String.length(fr.branch_code) == 5

      assert fr.account_number == "0500013M026"
      assert String.length(fr.account_number) == 11

      assert fr.national_check == "06"
      assert String.length(fr.national_check) == 2
    end

    test "Russia - longest with 9-digit bank, 5-digit branch (9!n5!n15!n)" do
      longest = TestData.edge_cases().longest
      {:ok, ru} = Parser.parse(longest)

      assert String.length(ru.bank_code) == 9
      assert String.length(ru.branch_code) == 5
      assert String.length(ru.account_number) == 15
    end

    test "Norway - shortest with minimal structure (4!n6!n1!n)" do
      {:ok, no} = Parser.parse("NO9386011117947")

      assert String.length(no.bank_code) == 4
      # 6 + 1 check digit
      assert String.length(no.account_number) == 7
      assert no.branch_code == nil
    end

    test "GB - 6-digit sort code as branch (4!a6!n8!n)" do
      {:ok, gb} = Parser.parse("GB29NWBK60161331926819")

      assert gb.bank_code == "NWBK"
      assert String.length(gb.bank_code) == 4

      assert gb.branch_code == "601613"
      assert String.length(gb.branch_code) == 6

      assert gb.account_number == "31926819"
      assert String.length(gb.account_number) == 8
    end
  end

  describe "Registry metadata validation" do
    test "registry contains 105 total countries/territories" do
      fixtures = TestData.load_fixtures()
      metadata = fixtures["metadata"]

      assert metadata["total_countries"] == 105
    end

    test "registry contains 53 SEPA countries" do
      fixtures = TestData.load_fixtures()
      metadata = fixtures["metadata"]

      assert metadata["sepa_countries"] == 53
    end

    test "registry source is SWIFT IBAN Registry" do
      fixtures = TestData.load_fixtures()
      metadata = fixtures["metadata"]

      assert metadata["source"] == "SWIFT IBAN Registry"
    end

    test "all countries have complete specifications" do
      TestData.all_country_codes()
      |> Enum.each(fn country_code ->
        spec = TestData.country_spec(country_code)

        assert spec["country_name"] != nil
        assert spec["iban_length"] != nil
        assert spec["bban_length"] != nil
        assert spec["iban_spec"] != nil
        assert spec["bban_spec"] != nil
        assert Map.has_key?(spec, "sepa")
        assert spec["positions"] != nil
      end)
    end
  end

  describe "Print format vs Electronic format" do
    test "validates both formats for all countries" do
      fixtures = TestData.load_fixtures()

      Enum.each(fixtures["valid_ibans"], fn {_code, data} ->
        electronic = data["electronic"]
        print = data["print"]

        assert TestData.valid?(electronic),
               "Electronic format validation failed: #{electronic}"

        assert TestData.valid?(print),
               "Print format validation failed: #{print}"
      end)
    end

    test "electronic and print formats normalize to same value" do
      fixtures = TestData.load_fixtures()

      Enum.each(fixtures["valid_ibans"], fn {_code, data} ->
        electronic = data["electronic"]
        print = data["print"]

        {:ok, from_electronic} = Parser.parse(electronic)
        {:ok, from_print} = Parser.parse(print)

        assert from_electronic.iban == from_print.iban,
               "Normalization mismatch: #{electronic} vs #{print}"
      end)
    end
  end
end
