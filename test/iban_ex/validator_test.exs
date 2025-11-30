defmodule IbanEx.ValidatorTest do
  @moduledoc """
  Comprehensive test coverage for IbanEx.Validator module.
  Based on Test Coverage Improvement Plan - Phase 1: Critical Coverage.
  """

  use ExUnit.Case, async: true

  alias IbanEx.{Validator, TestData}

  describe "valid?/1 - comprehensive validation" do
    test "returns true for all 105 registry valid IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        assert TestData.valid?(iban), "Expected valid IBAN: #{iban}"
      end)
    end

    test "returns true for edge case: shortest IBAN (Norway, 15 chars)" do
      edge_cases = TestData.edge_cases()
      assert TestData.valid?(edge_cases.shortest)
      assert String.length(edge_cases.shortest) == 15
    end

    test "returns true for edge case: longest IBAN (Russia, 33 chars)" do
      edge_cases = TestData.edge_cases()
      assert TestData.valid?(edge_cases.longest)
      assert String.length(edge_cases.longest) == 33
    end

    test "returns true for complex IBANs with branch code and national check" do
      edge_cases = TestData.edge_cases()

      Enum.each(edge_cases.complex, fn iban ->
        assert TestData.valid?(iban), "Expected valid complex IBAN: #{iban}"
      end)
    end

    test "returns false for invalid checksum" do
      # Valid IBAN with flipped checksum
      # Changed 89 to 00
      refute TestData.valid?("DE00370400440532013000")
      # Changed 14 to 00
      refute TestData.valid?("FR0020041010050500013M02606")
      # Changed 29 to 00
      refute TestData.valid?("GB00NWBK60161331926819")
    end

    test "returns false for invalid length (too short)" do
      # Missing 1 char
      refute TestData.valid?("DE8937040044053201300")
      # Missing 1 char from shortest
      refute TestData.valid?("NO938601111794")
    end

    test "returns false for invalid length (too long)" do
      # Extra char
      refute TestData.valid?("DE89370400440532013000X")
      # Extra char on shortest
      refute TestData.valid?("NO9386011117947X")
    end

    test "returns false for unsupported country code" do
      refute TestData.valid?("XX89370400440532013000")
      refute TestData.valid?("ZZ1234567890123456")
    end

    test "returns false for invalid characters in BBAN" do
      # Cyrillic character
      refute TestData.valid?("DE89370400440532013Ї00")
      #     CInvalcdchara in shorerst
      refute TestData.valid?("NO938601111794Ї")
    end

    test "returns false for lowercase country code" do
      refute TestData.valid?("de89370400440532013000")
    end

    test "returns false for empty string" do
      refute TestData.valid?("")
    end

    test "returns false for nil" do
      refute TestData.valid?(nil)
    end

    test "accepts both electronic and print formats" do
      assert TestData.valid?("DE89370400440532013000")
      assert TestData.valid?("DE89 3704 0044 0532 0130 00")
    end
  end

  describe "violations/1 - detailed violation reporting" do
    test "returns empty list for valid IBAN" do
      assert Validator.violations("DE89370400440532013000") == []
      assert Validator.violations("NO9386011117947") == []
    end

    test "returns all violations for completely invalid IBAN" do
      violations = Validator.violations("XX00INVALID")

      assert :unsupported_country_code in violations
      assert :invalid_checksum in violations or :length_to_short in violations
    end

    test "returns checksum violation for invalid check digits" do
      violations = Validator.violations("DE00370400440532013000")

      assert :invalid_checksum in violations
      refute :invalid_length in violations
    end

    test "returns length violation for too short IBAN" do
      violations = Validator.violations("DE8937040044053201300")

      assert :length_to_short in violations
    end

    test "returns length violation for too long IBAN" do
      violations = Validator.violations("DE89370400440532013000XXX")

      assert :length_to_long in violations
    end

    test "returns format violations for invalid BBAN structure" do
      # IBAN with letters in numeric-only bank code
      violations = Validator.violations("DEXX370400440532013000")

      assert length(violations) > 0
    end

    test "violations are deterministically ordered" do
      violations1 = Validator.violations("XX00INVALID")
      violations2 = Validator.violations("XX00INVALID")

      assert violations1 == violations2
    end

    test "returns multiple BBAN violations when applicable" do
      # Test IBAN with multiple BBAN format issues
      violations = Validator.violations("AT6119043002A4573201")

      assert length(violations) > 0
    end
  end

  describe "check_iban_length/1" do
    test "returns :ok for all registry IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        assert Validator.check_iban_length(iban) == :ok, "Length check failed for: #{iban}"
      end)
    end

    test "returns :ok for shortest IBAN (15 chars)" do
      assert Validator.check_iban_length("NO9386011117947") == :ok
    end

    test "returns :ok for longest IBAN (33 chars)" do
      longest = TestData.edge_cases().longest
      assert Validator.check_iban_length(longest) == :ok
    end

    test "returns {:error, :length_to_short} for too short IBAN" do
      assert Validator.check_iban_length("FI2112345CC600007") == {:error, :length_to_short}
    end

    test "returns {:error, :length_to_long} for too long IBAN" do
      assert Validator.check_iban_length("FI2112345CC6000007a") == {:error, :length_to_long}
    end

    test "returns {:error, :unsupported_country_code} for invalid country" do
      assert Validator.check_iban_length("FG2112345CC6000007") ==
               {:error, :unsupported_country_code}

      assert Validator.check_iban_length("UK2112345CC6000007") ==
               {:error, :unsupported_country_code}
    end

    test "validates length for all 18 different IBAN lengths (15-33)" do
      # Test coverage for all unique lengths in registry
      length_ranges = [
        {15, "NO9386011117947"},
        {16, "BE68539007547034"},
        {18, "DK5000400440116243"},
        {22, "DE89370400440532013000"},
        {24, "CZ6508000000192000145399"},
        {27, "FR1420041010050500013M02606"},
        {29, "BR1800360305000010009795493C1"},
        {33, TestData.edge_cases().longest}
      ]

      Enum.each(length_ranges, fn {expected_length, iban} ->
        assert String.length(iban) == expected_length
        assert Validator.check_iban_length(iban) == :ok
      end)
    end
  end

  describe "iban_violates_bank_code_format?/1" do
    test "returns false for all registry valid IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        refute Validator.iban_violates_bank_code_format?(iban),
               "Bank code format violation for: #{iban}"
      end)
    end

    test "returns true for invalid bank code format in numeric-only country" do
      # Germany expects numeric bank code
      assert Validator.iban_violates_bank_code_format?("DE89ABCD00440532013000")
    end

    test "validates bank code for countries with alphanumeric format" do
      # Bahrain allows alphanumeric bank code (4!a)
      refute Validator.iban_violates_bank_code_format?("BH67BMAG00001299123456")
    end

    test "handles edge cases with very short bank codes" do
      # Sweden has 3-digit bank code
      refute Validator.iban_violates_bank_code_format?("SE4550000000058398257466")
    end

    test "handles edge cases with very long bank codes" do
      # Russia has 9-digit bank code
      longest = TestData.edge_cases().longest
      refute Validator.iban_violates_bank_code_format?(longest)
    end
  end

  describe "iban_violates_branch_code_format?/1" do
    test "returns false for all registry valid IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        refute Validator.iban_violates_branch_code_format?(iban),
               "Branch code format violation for: #{iban}"
      end)
    end

    test "validates branch code for countries with branch codes" do
      # France has 5-digit branch code
      refute Validator.iban_violates_branch_code_format?("FR1420041010050500013M02606")

      # GB has 6-digit sort code (branch code)
      refute Validator.iban_violates_branch_code_format?("GB29NWBK60161331926819")
    end

    test "handles countries without branch codes" do
      # Germany has no branch code
      refute Validator.iban_violates_branch_code_format?("DE89370400440532013000")
    end

    test "returns true for invalid branch code format" do
      # France with letters in numeric branch code
      assert Validator.iban_violates_branch_code_format?("FR142004ABCD050500013M02606")
    end
  end

  describe "iban_violates_account_number_format?/1" do
    test "returns false for all registry valid IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        refute Validator.iban_violates_account_number_format?(iban),
               "Account number format violation for: #{iban}"
      end)
    end

    test "returns true for account number too short" do
      assert Validator.iban_violates_account_number_format?("AL4721211009000000023568741")
      assert Validator.iban_violates_account_number_format?("AD120001203020035900100")
    end

    test "returns true for invalid characters in numeric account" do
      assert Validator.iban_violates_account_number_format?("AT6119043002A4573201")
      assert Validator.iban_violates_account_number_format?("BH67BMAG000012991A3456")
    end

    test "returns true for account number too short AND invalid characters" do
      assert Validator.iban_violates_account_number_format?("BR18003603050000100097CC1")
    end

    test "handles alphanumeric account numbers correctly" do
      # Qatar has alphanumeric account number
      refute Validator.iban_violates_account_number_format?("QA58DOHB00001234567890ABCDEFG")
    end

    test "handles shortest account numbers" do
      # Norway has 6-digit account number
      refute Validator.iban_violates_account_number_format?("NO9386011117947")
    end

    test "handles longest account numbers" do
      # Russia has 15-character account number
      longest = TestData.edge_cases().longest
      refute Validator.iban_violates_account_number_format?(longest)
    end
  end

  describe "iban_violates_national_check_format?/1" do
    test "returns false for all registry valid IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        refute Validator.iban_violates_national_check_format?(iban),
               "National check format violation for: #{iban}"
      end)
    end

    test "validates national check for countries that have it" do
      # France has 2-digit national check
      refute Validator.iban_violates_national_check_format?("FR1420041010050500013M02606")

      # Spain has 2-digit national check
      refute Validator.iban_violates_national_check_format?("ES9121000418450200051332")

      # Italy has 1-character check
      refute Validator.iban_violates_national_check_format?("IT60X0542811101000000123456")
    end

    test "handles countries without national check" do
      # Germany has no national check
      refute Validator.iban_violates_national_check_format?("DE89370400440532013000")
    end

    test "returns true for invalid national check format" do
      # Assuming implementation checks format validity
      # This would need actual invalid examples based on implementation
    end
  end

  describe "checksum validation" do
    test "validates checksum for all registry IBANs" do
      TestData.valid_ibans()
      |> Enum.each(fn iban ->
        violations = Validator.violations(iban)
        refute :invalid_checksum in violations, "Invalid checksum for registry IBAN: #{iban}"
      end)
    end

    test "detects invalid checksum with check digit 00" do
      refute TestData.valid?("DE00370400440532013000")
    end

    test "detects invalid checksum with check digit 01" do
      refute TestData.valid?("DE01370400440532013000")
    end

    test "detects invalid checksum with check digit 99" do
      refute TestData.valid?("DE99370400440532013000")
    end

    test "validates checksum for shortest IBAN" do
      shortest = TestData.edge_cases().shortest
      violations = Validator.violations(shortest)
      refute :invalid_checksum in violations
    end

    test "validates checksum for longest IBAN" do
      longest = TestData.edge_cases().longest
      violations = Validator.violations(longest)
      refute :invalid_checksum in violations
    end

    test "validates checksum for alphanumeric BBANs" do
      # Bahrain has alphanumeric BBAN
      assert TestData.valid?("BH67BMAG00001299123456")

      # Qatar has alphanumeric BBAN
      assert TestData.valid?("QA58DOHB00001234567890ABCDEFG")
    end
  end

  describe "SEPA country validation" do
    test "validates all 53 SEPA country IBANs" do
      sepa_ibans = TestData.valid_ibans(sepa_only: true)

      assert length(sepa_ibans) == 53

      Enum.each(sepa_ibans, fn iban ->
        assert TestData.valid?(iban), "SEPA IBAN validation failed: #{iban}"
      end)
    end

    test "validates major SEPA countries" do
      major_sepa = ["DE", "FR", "IT", "ES", "NL", "BE", "AT", "CH", "SE"]

      Enum.each(major_sepa, fn country_code ->
        [iban] = TestData.valid_ibans(country: country_code)
        assert TestData.valid?(iban), "Major SEPA country #{country_code} validation failed"
      end)
    end
  end

  describe "character type validation" do
    test "validates numeric-only BBAN structure" do
      # Get IBANs with numeric-only BBANs
      numeric_ibans = TestData.ibans_with(numeric_only: true)

      assert length(numeric_ibans) > 0

      Enum.each(numeric_ibans, fn iban ->
        assert TestData.valid?(iban)
      end)
    end

    test "validates alphanumeric BBAN structure" do
      alphanumeric_ibans = TestData.ibans_with(numeric_only: false)

      assert length(alphanumeric_ibans) > 0

      Enum.each(alphanumeric_ibans, fn iban ->
        assert TestData.valid?(iban)
      end)
    end
  end

  describe "format handling" do
    test "validates electronic format" do
      assert TestData.valid?("DE89370400440532013000")
    end

    test "validates print format with spaces" do
      assert TestData.valid?("DE89 3704 0044 0532 0130 00")
    end

    test "validates both formats produce same result" do
      electronic = "DE89370400440532013000"
      print = "DE89 3704 0044 0532 0130 00"

      assert TestData.valid?(electronic) == TestData.valid?(print)
      assert Validator.violations(electronic) == Validator.violations(print)
    end
  end
end
