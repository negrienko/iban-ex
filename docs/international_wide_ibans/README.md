# IBAN Registry - Single Source of Truth

This directory contains the **official SWIFT IBAN Registry** data and tools to parse it into test fixtures for the IbanEx library.

## 🎯 Purpose

This is the **single source of truth** for IBAN validation rules, formats, and test data. All test cases should be derived from this official registry to ensure accuracy and compliance with international standards.

## 📁 Files

### Source Data
- **`iban-registry-100.txt`** - Official SWIFT IBAN Registry (Release 100) in TXT format
  - Source: https://www.swift.com/standards/data-standards/iban
  - Contains: 89 base countries + territories = 105 total country codes
  - Format: Tab-separated values with CRLF line endings
  - Encoding: Latin-1 (ISO-8859-1)

### Processing Scripts
- **`get_iban_registry.py`** - Original script to fetch from SWIFT website (requires network)
- **`parse_local_registry.py`** - **Recommended** parser for local `iban-registry-100.txt` file

### Generated Fixtures
- **`iban_registry_full.json`** (88 KB) - Complete registry with all fields
- **`iban_test_fixtures.json`** (81 KB) - Simplified fixtures for testing

## 🚀 Quick Start

### Generate Test Fixtures

```bash
cd docs/international_wide_ibans
python3 parse_local_registry.py
```

**Output:**
```
✓ Parsed 89 records
✓ Processed 105 country codes
✓ Generated fixtures for 105 countries
✓ SEPA countries: 53
✓ Saved: iban_registry_full.json
✓ Saved: iban_test_fixtures.json
```

### Use in Elixir Tests

```elixir
# In your test setup
defmodule IbanEx.RegistryFixtures do
  @fixtures_path "docs/international_wide_ibans/iban_test_fixtures.json"
  
  @external_resource @fixtures_path
  @fixtures @fixtures_path
            |> File.read!()
            |> Jason.decode!()
  
  def all_valid_ibans do
    @fixtures["valid_ibans"]
    |> Enum.map(fn {_code, data} -> data["electronic"] end)
  end
  
  def valid_iban(country_code) do
    @fixtures["valid_ibans"][country_code]["electronic"]
  end
  
  def country_spec(country_code) do
    @fixtures["country_specs"][country_code]
  end
  
  def sepa_countries do
    @fixtures["country_specs"]
    |> Enum.filter(fn {_code, spec} -> spec["sepa"] end)
    |> Enum.map(fn {code, _spec} -> code end)
  end
end
```

## 📊 Registry Statistics

### Coverage
- **Total Countries/Territories:** 105
- **SEPA Countries:** 53
- **Non-SEPA Countries:** 52

### IBAN Length Distribution
| Length | Count | Example Countries |
|--------|-------|-------------------|
| 15 | 1 | Norway (NO) - **Shortest** |
| 16 | 1 | Belgium (BE) |
| 18 | 8 | Denmark (DK), Finland (FI), Greenland (GL), Faroe Islands (FO) |
| 19 | 2 | Mongolia (MN), Slovakia (SK) |
| 20 | 8 | Austria (AT), Estonia (EE), Kosovo (XK) |
| 21 | 4 | Switzerland (CH), Croatia (HR), Latvia (LV), Lithuania (LT) |
| 22 | 13 | Germany (DE), Bulgaria (BG), Georgia (GE), Bahrain (BH) |
| 23 | 7 | UAE (AE), Israel (IL), Iraq (IQ), Iceland (IS), Qatar (QA), El Salvador (SV) |
| 24 | 11 | Andorra (AD), Czech Republic (CZ), Spain (ES), Poland (PL), Romania (RO), San Marino (SM) |
| 25 | 3 | Libya (LY), Portugal (PT), Serbia (RS) |
| 26 | 2 | Italy (IT), Yemen (YE) |
| 27 | 20 | France (FR), Greece (GR), Burundi (BI), many territories |
| 28 | 12 | Albania (AL), Azerbaijan (AZ), Cyprus (CY), Dominican Republic (DO), Nicaragua (NI) |
| 29 | 5 | Brazil (BR), Egypt (EG), Pakistan (PK), Qatar (QA) |
| 30 | 4 | Jordan (JO), Kuwait (KW), Mauritius (MU) |
| 31 | 2 | Malta (MT), Sweden (SE) |
| 32 | 1 | Saint Lucia (LC) |
| 33 | 1 | Russia (RU) - **Longest** |

### Special Characteristics

**Shortest IBAN:**
- **NO** (Norway) - 15 characters
- Example: `NO9386011117947`

**Longest IBAN:**
- **RU** (Russian Federation) - 33 characters
- Example: `RU0304452522540817810538091310419`

**SEPA Countries Include Territories:**
- **FR** (France): GF, GP, MQ, YT, RE, PM, BL, MF
- **GB** (United Kingdom): IM, JE, GG
- **FI** (Finland): AX (Åland Islands)
- **PT** (Portugal): Azores, Madeira
- **ES** (Spain): AX (listed separately)

## 📋 Data Structure

### Valid IBANs (`iban_test_fixtures.json`)

```json
{
  "valid_ibans": {
    "DE": {
      "electronic": "DE89370400440532013000",
      "print": "DE89 3704 0044 0532 0130 00",
      "country_name": "Germany"
    }
  },
  "country_specs": {
    "DE": {
      "country_name": "Germany",
      "iban_length": 22,
      "bban_length": 18,
      "iban_spec": "DE2!n8!n10!n",
      "bban_spec": "8!n10!n",
      "sepa": true,
      "positions": {
        "bank_code": {
          "start": 0,
          "end": 8,
          "pattern": "8!n",
          "example": "37040044"
        },
        "branch_code": {
          "start": 8,
          "end": 8,
          "pattern": "",
          "example": ""
        },
        "account_code": {
          "start": 8,
          "end": 18,
          "example": "0532013000"
        }
      },
      "effective_date": "Jul-07"
    }
  },
  "metadata": {
    "total_countries": 105,
    "sepa_countries": 53,
    "source": "SWIFT IBAN Registry",
    "format_version": "TXT Release 100"
  }
}
```

### Full Registry (`iban_registry_full.json`)

Contains additional fields:
- `other_territories`: List of territory codes covered
- `parent_country`: For territories, reference to parent country
- Complete BBAN structure specifications
- All position information with patterns and examples

## 🔍 Pattern Specifications

IBAN and BBAN structures use these format codes:

- **`n`** - Numeric digits (0-9)
- **`a`** - Uppercase alphabetic letters (A-Z)
- **`c`** - Alphanumeric characters (A-Z, 0-9)
- **`!`** - Fixed length indicator
- **Number** - Length of the field

**Examples:**
- `DE2!n8!n10!n` = DE + 2 check digits + 8 numeric (bank) + 10 numeric (account)
- `FR2!n5!n5!n11!c2!n` = FR + 2 check digits + 5n (bank) + 5n (branch) + 11c (account) + 2n (check)

## ✅ Test Coverage Validation

### Using Registry for Comprehensive Tests

```elixir
defmodule IbanEx.RegistryValidationTest do
  use ExUnit.Case, async: true
  
  @fixtures "docs/international_wide_ibans/iban_test_fixtures.json"
            |> File.read!()
            |> Jason.decode!()
  
  describe "validate against official SWIFT registry" do
    test "all registry IBANs parse successfully" do
      for {code, data} <- @fixtures["valid_ibans"] do
        iban = data["electronic"]
        
        assert {:ok, parsed} = IbanEx.Parser.parse(iban),
               "Failed to parse official IBAN for #{code}: #{iban}"
        
        assert parsed.country_code == code
      end
    end
    
    test "all registry IBANs pass validation" do
      for {_code, data} <- @fixtures["valid_ibans"] do
        iban = data["electronic"]
        
        assert {:ok, _} = IbanEx.Validator.validate(iban),
               "Validation failed for official IBAN: #{iban}"
      end
    end
    
    test "all registry IBANs have correct length" do
      for {code, data} <- @fixtures["valid_ibans"] do
        iban = data["electronic"]
        spec = @fixtures["country_specs"][code]
        
        assert String.length(iban) == spec["iban_length"],
               "Length mismatch for #{code}: expected #{spec["iban_length"]}, got #{String.length(iban)}"
      end
    end
    
    test "SEPA countries match registry" do
      sepa_countries = @fixtures["country_specs"]
                      |> Enum.filter(fn {_code, spec} -> spec["sepa"] end)
                      |> Enum.map(fn {code, _} -> code end)
                      |> MapSet.new()
      
      # Compare with your implementation
      our_sepa = IbanEx.Country.sepa_countries() |> MapSet.new()
      
      assert MapSet.equal?(sepa_countries, our_sepa),
             "SEPA country mismatch. Missing: #{inspect(MapSet.difference(sepa_countries, our_sepa))}, Extra: #{inspect(MapSet.difference(our_sepa, sepa_countries))}"
    end
  end
end
```

### Regression Test Generation

```elixir
defmodule IbanEx.RegistryRegressionTest do
  use ExUnit.Case, async: true
  
  @fixtures "docs/international_wide_ibans/iban_test_fixtures.json"
            |> File.read!()
            |> Jason.decode!()
  
  for {code, data} <- @fixtures["valid_ibans"] do
    @tag :registry
    test "#{code} - #{data["country_name"]}: parses and validates" do
      iban = unquote(data["electronic"])
      
      # Parse
      assert {:ok, parsed} = IbanEx.Parser.parse(iban)
      assert parsed.country_code == unquote(code)
      
      # Validate
      assert {:ok, _} = IbanEx.Validator.validate(iban)
      
      # Round-trip
      formatted = IbanEx.Formatter.compact(parsed)
      assert formatted == iban
    end
  end
end
```

## 🔄 Updating the Registry

### When to Update
- SWIFT releases new IBAN Registry version
- New countries added to IBAN system
- Existing country specifications change
- SEPA membership changes

### Update Process

1. **Download latest registry:**
   - Visit: https://www.swift.com/standards/data-standards/iban
   - Download "IBAN Registry (TXT)" file
   - Save as `iban-registry-XXX.txt` (where XXX is version)

2. **Update references:**
   ```bash
   mv iban-registry-XXX.txt iban-registry-100.txt  # Update to new version
   ```

3. **Regenerate fixtures:**
   ```bash
   python3 parse_local_registry.py
   ```

4. **Run regression tests:**
   ```bash
   mix test --only registry
   ```

5. **Review changes:**
   ```bash
   git diff iban_test_fixtures.json
   ```

6. **Update IbanEx country modules if needed:**
   - Compare new specs with existing `lib/iban_ex/country/*.ex` files
   - Add new countries as needed
   - Update changed specifications

## 📖 References

### Official Sources
- **SWIFT IBAN Registry:** https://www.swift.com/standards/data-standards/iban
- **IBAN Standard (ISO 13616):** https://www.iso.org/standard/81090.html
- **SEPA:** https://www.europeanpaymentscouncil.eu/

### Additional Resources
- **IBAN Structure:** https://en.wikipedia.org/wiki/International_Bank_Account_Number
- **Modulo 97 Check Digit:** ISO/IEC 7064, MOD 97-10
- **SWIFT Standards:** https://www.swift.com/standards

## 🧪 Test Data Best Practices

### DO ✅
- **Use registry data** for valid IBAN examples
- **Generate invalid IBANs** by mutating valid ones from registry
- **Test all countries** from the registry
- **Verify IBAN length** against registry specifications
- **Check SEPA status** from registry metadata
- **Use official examples** for documentation

### DON'T ❌
- Hard-code IBAN examples without verifying against registry
- Assume IBAN length is constant across countries
- Skip testing edge cases (shortest: NO, longest: RU)
- Ignore territory codes (they share parent country rules)
- Test with outdated IBAN formats

## 🔧 Troubleshooting

### Parser Issues

**Problem:** `ValueError: max() arg is an empty sequence`
- **Cause:** File encoding mismatch or wrong line endings
- **Solution:** Ensure file is Latin-1 encoded with CRLF endings

**Problem:** Missing country codes
- **Cause:** Incorrect tab parsing
- **Solution:** Verify `\t` separator and handle empty cells

### Fixture Generation

**Problem:** Some countries missing in output
- **Cause:** Empty country code or IBAN example
- **Solution:** Check source file for completeness

**Problem:** Position ranges incorrect
- **Cause:** Off-by-one error in range parsing
- **Solution:** Verify 1-indexed to 0-indexed conversion

## 📝 License & Attribution

- **Source Data:** © SWIFT - Society for Worldwide Interbank Financial Telecommunication
- **Usage:** For validation and testing purposes in accordance with SWIFT standards
- **Parser Script:** Open source, provided as-is

## 🤝 Contributing

When adding tests based on this registry:

1. Reference the specific registry version used (e.g., "Release 100")
2. Include the generation date in test documentation
3. Link test cases to registry entries by country code
4. Document any discrepancies between registry and implementation

---

**Last Updated:** 2025-01-29  
**Registry Version:** Release 100  
**Total Countries:** 105  
**Parser Version:** 1.0.0
