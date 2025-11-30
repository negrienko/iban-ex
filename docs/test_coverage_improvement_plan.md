# IbanEx Test Coverage Improvement Plan
**Comprehensive Merged Analysis**

## Executive Summary

This comprehensive test coverage improvement plan consolidates insights from detailed codebase analysis to identify critical testing gaps in the IbanEx library. The analysis reveals that while basic validation and parsing have initial coverage through doctests and happy-path tests, **critical security and reliability functions remain completely untested**, including error handling, data serialization, and negative test cases.

### Key Findings
- **Current Coverage:** ~40-50% (estimated)
- **Critical Risk:** Core validation functions (`violations/1`, `validate/1`, checksum verification) are **untested**
- **Data Safety Gap:** Serialization/deserialization protocols can silently accept malformed data
- **Missing Safety Nets:** No negative tests, edge cases, or malformed input handling verification

### Strategic Approach
- **4-Phase Implementation:** Prioritized by risk (Critical → High → Medium → Polish)
- **Expected Outcome:** 90%+ coverage with comprehensive safety nets
- **Timeline:** 8 weeks to complete all phases

---

## 1. Current Test Coverage Analysis

### 1.1 Existing Test Files
```
test/
├── iban_ex_test.exs           # Doctest aggregator (70+ countries)
├── iban_ex_parser_test.exs    # Parser validation (2 test cases)
├── iban_ex_validator_test.exs # Validator tests (6 test cases)
└── test_helper.exs             # Test configuration
```

### 1.2 Current Strengths ✅
- Basic IBAN validation for all 70+ supported countries
- Parser functionality for valid and invalid country codes
- Some BBAN component validation (account number, bank code, branch code, national check)
- Length validation for 5 countries
- Doctests ensure per-country formatting examples compile

### 1.3 Critical Weaknesses ❌

#### Completely Untested Modules (0% Coverage)
1. **`IbanEx.Validator.violations/1`** - Core aggregation function
2. **`IbanEx.Validator.validate/1`** - Primary validation API
3. **`IbanEx.Validator.iban_violates_checksum?/1`** - Security-critical function
4. **`IbanEx.Deserialize` protocol** - All implementations (String, Map, List)
5. **`IbanEx.Serialize` module** - `to_string/1` and `to_map/1`
6. **`IbanEx.Formatter` module** - All formatting functions
7. **`IbanEx.Iban` struct** - Delegates and structure
8. **`IbanEx.Commons`** - Normalization utilities
9. **`IbanEx.Error`** - Error message generation
10. **`IbanEx.Country`** - Discovery and module lookup functions

#### Partially Tested (Only Happy Paths)
1. **`IbanEx.Parser`** - Missing: `incomplete: true`, `parse_bban/3`, edge cases
2. **`IbanEx.Validator`** - Missing: negative tests, all error branches
3. **Country modules** - Only indirect doctest coverage

---

## 2. High-Risk Gaps (Critical Priority)

### 2.1 Validator Pipeline (`lib/iban_ex/validator/validator.ex`)
**Risk Level:** 🔴 **CRITICAL** - Primary security and data validation surface

#### Untested Functions
```elixir
# Public API - COMPLETELY UNTESTED
validate/1              # Returns {:ok, iban} | {:error, reason}
violations/1            # Returns list of all violations

# Internal Guards - NO NEGATIVE TESTS
iban_violates_format?/1          # Format validation
iban_unsupported_country?/1      # Country code validation
iban_violates_length?/1          # Length validation
iban_violates_country_rule?/1    # BBAN structure validation
iban_violates_checksum?/1        # 🔐 SECURITY CRITICAL - mod 97 check

# BBAN Component Validators
check_iban_bank_code/1           # Only 5 countries tested
check_iban_account_number/1      # Only 5 countries tested
check_iban_branch_code/1         # Only 5 countries tested
check_iban_national_check/1      # Only 5 countries tested
```

#### Required Test Coverage
1. **`violations/1` Tests:**
   - Empty list for valid IBANs
   - All violations for completely invalid input
   - Specific violations for targeted errors (checksum only, length only, etc.)
   - Multiple simultaneous violations
   - Deterministic ordering of violation list

2. **`validate/1` Tests:**
   - All error tuple types: `:invalid_format`, `:unsupported_country_code`, `:invalid_length`, `:invalid_format_for_country`, `:invalid_bank_code`, `:invalid_account_number`, `:invalid_branch_code`, `:invalid_national_check`, `:invalid_checksum`
   - Success case returns correct `{:ok, %Iban{}}` structure

3. **Checksum Validation (`iban_violates_checksum?/1`):**
   - Valid checksums (02-96, 98)
   - Invalid by algorithm (01, 00, 97, 99)
   - All-numeric BBANs
   - All-alphabetic BBANs
   - Mixed alphanumeric BBANs
   - Edge case countries (QA with heavy letter usage)

4. **Replacements Module (`lib/iban_ex/validator/replacements.ex`):**
   - Verify `replace/1` letter-to-number mapping
   - Confirm complete A-Z coverage
   - Validate fallback behavior

### 2.2 Parser Module (`lib/iban_ex/parser.ex`)
**Risk Level:** 🔴 **CRITICAL** - Entry point for all IBAN data

#### Untested Functions & Branches
```elixir
parse/2                 # Missing: incomplete: true option
parse_bban/3           # Completely untested
country_code/1         # Missing: edge cases
check_digits/1         # Missing: edge cases
bban/1                 # Missing: edge cases
```

#### Required Test Coverage
1. **`parse/2` Edge Cases:**
   ```elixir
   # Input validation
   - Empty strings
   - Nil values
   - Strings with only country code
   - Strings with country + check digits but no BBAN
   - Special characters (!@#$%^&*)
   - Extremely long strings (>1000 chars)
   - Non-ASCII / Unicode characters
   - Emoji in input
   
   # incomplete: true option
   - Partial IBAN strings
   - IBANs missing BBAN components
   - Malformed partial data
   ```

2. **`parse_bban/3` Tests:**
   - Empty BBAN strings
   - BBAN with invalid characters
   - BBAN length mismatches
   - Both `incomplete: false` (regex) and `incomplete: true` (rules) modes
   - Fallback to `%{}` when regex captures fail

3. **Helper Functions:**
   - `country_code/1`: strings too short, lowercase, with whitespace
   - `check_digits/1`: non-numeric, single digit, letters
   - `bban/1`: strings shorter than 4 characters

### 2.3 Data Serialization & Deserialization
**Risk Level:** 🔴 **CRITICAL** - Silent data corruption risk

#### Deserialize Protocol (`lib/iban_ex/deserialize.ex`)
**0% Coverage** - All implementations untested:

```elixir
# String/BitString implementation
- Valid IBAN strings
- Invalid IBAN strings
- Empty strings
- Nil handling
- Error tuple propagation

# Map implementation (atom keys)
- Valid maps with all required fields
- Maps with optional fields as nil
- Maps missing required fields (:country_code, :check_digits, etc.)
- Maps with extra fields
- Invalid field values

# Map implementation (string keys)
- Valid maps with string keys
- Partial maps
- Mixed atom/string keys

# Keyword List implementation
- Valid keyword lists
- Keyword lists with optional fields
- Empty lists
- Lists with invalid data

# Error handling
- {:can_not_parse_map, _} error cases
- Protocol not implemented for other types
```

#### Serialize Module (`lib/iban_ex/serialize.ex`)
**0% Coverage:**

```elixir
# to_string/1
- Serialize valid IBANs
- Serialize IBANs with optional fields (nil branch_code, nil national_check)
- Output format verification (compact representation)

# to_map/1
- Convert Iban struct to map
- Verify all fields present
- Verify correct field types
- Handle nil optional fields (branch_code, national_check)

# Round-trip tests
- struct -> map -> struct preservation
- to_string/1 output can be parsed back
```

### 2.4 Formatter & User-Facing APIs
**Risk Level:** 🟡 **HIGH** - User experience and data presentation

#### Formatter Module (`lib/iban_ex/formatter.ex`)
**0% Coverage:**

```elixir
# available_formats/0
- Returns [:compact, :pretty, :splitted]
- Complete list validation

# format/2 and convenience functions
- compact/1: removes all spacing
- pretty/1: country-specific formatting rules
- splitted/1: 4-character block grouping
- format/2: all three format types
- Default format behavior

# Edge cases
- IBANs with nil optional fields
- Shortest IBAN (Norway: 15 chars)
- Longest IBAN (Malta: 31 chars)
- Round-trip: parse -> format -> parse preservation
```

#### Iban Struct (`lib/iban_ex/iban.ex`)
**0% Coverage:**

```elixir
# Struct validation
- Valid struct creation with all fields
- Struct with optional fields as nil
- Field types and defaults

# Delegated functions
- to_map/1 delegation to Serialize
- to_string/1 delegation to Serialize
- pretty/1, splitted/1, compact/1 delegations to Formatter

# Pattern matching
- Struct field access
- Pattern matching on struct
```

### 2.5 Country Modules Infrastructure
**Risk Level:** 🟡 **HIGH** - Foundation for all validations

#### Country Module (`lib/iban_ex/country.ex`)
**Minimal Coverage (doctests only):**

```elixir
# Discovery functions
supported_country_codes/0    # Returns all 70+ codes
supported_country_modules/0  # Returns all module atoms
country_module/1             # Lookup by code
is_country_code_supported?/1 # Boolean check

# Test requirements
- All functions with valid inputs
- Invalid country codes
- Case insensitivity (DE, de, De, dE)
- Atom vs string inputs
- Edge cases: nil, empty string, numbers, special chars
```

#### Country Implementation Modules (70+ files)
**Indirect Coverage Only (via doctests):**

Each module in `lib/iban_ex/country/*.ex` needs explicit tests:

```elixir
# Per-country validation
- size/0 returns correct length
- rule/0 returns valid regex
- rules/0 returns all BBAN part rules
- rules_map/0 field mappings are correct
- to_string/1 formats correctly
- BBAN structure validation
- Optional fields handling (branch_code, national_check)

# Shared test suite approach
- Iterate over Country.supported_country_modules/0
- Assert size/0 == regex length + 4
- Assert rules/0 and rules_map/0 produce contiguous ranges
- Assert ranges cover bban_size/0
- Negative tests: malformed BBANs per region
```

**High-priority countries for explicit tests:**
- DE (Germany) - Most common
- FR (France) - Complex format
- GB (United Kingdom) - Custom `to_string/1` override
- IT (Italy) - Has branch code and national check
- BR (Brazil) - Different character set
- NO (Norway) - Shortest IBAN (15 chars)
- MT (Malta) - Longest IBAN (31 chars)

### 2.6 Utility Modules
**Risk Level:** 🟡 **HIGH** - Shared dependencies

#### Commons Module (`lib/iban_ex/commons/commons.ex`)
**0% Coverage:**

```elixir
# blank/1
- Empty strings
- Whitespace-only strings
- Nil values
- Non-empty strings

# normalize/1
- Removes spaces and hyphens
- Converts to uppercase
- Handles nil
- Handles already normalized strings
- Unicode handling

# normalize_and_slice/2
- Correct slicing after normalization
- Edge cases with ranges
- Empty results
- Out-of-bounds ranges
- Negative indices
```

#### Error Module (`lib/iban_ex/error.ex`)
**0% Coverage:**

```elixir
# message/1
- All declared error atoms return messages
- Messages are human-readable
- Unknown atoms fall back to "Undefined error"
- Consistent error message format
```

---

## 3. Integration & End-to-End Testing Gaps

### 3.1 End-to-End Workflows
**Currently Missing:**

```elixir
# Complete IBAN lifecycle
String -> Parse -> Validate -> Format -> String (round-trip)
Map -> Deserialize -> Serialize -> Map (round-trip)
Invalid input -> Error handling -> Error messages

# Cross-module integration
Parser + Validator integration
Formatter + Parser integration
Deserialize + Serialize integration
Country module + Validator integration
```

### 3.2 Real-World Scenarios
**Banking Use Cases:**

```elixir
# Bulk operations
- Validate 1000+ IBANs (performance)
- IBAN conversion between formats in batch
- Database serialization/deserialization patterns

# API integration
- JSON request/response handling (via Deserialize protocol)
- Multi-country IBAN processing
- Error propagation through application layers

# Error scenarios
- Graceful degradation with partial data
- Error recovery strategies
- User-friendly error messages
```

---

## 4. Edge Cases & Boundary Testing

### 4.1 Input Validation Edge Cases

```elixir
# Null and empty handling
- nil inputs to all public functions
- Empty strings ("")
- Whitespace-only strings ("   ", "\t", "\n")

# Character encoding
- UTF-8 edge cases
- Non-ASCII characters (ñ, ö, ü, etc.)
- Emoji in IBANs (should fail gracefully: 💰, 🏦)
- Different whitespace characters (\t, \n, \r, non-breaking space)

# Size boundaries
- Minimum valid IBAN length (15 chars - Norway)
- Maximum valid IBAN length (34 chars - Malta theoretical max, 31 practical)
- Off-by-one errors (length ± 1)
- Extremely short (<15)
- Extremely long (>34)

# Type boundaries
- Integer inputs (should fail with proper errors)
- Float inputs
- Boolean inputs
- List inputs (where not expected)
- Atom inputs (where not expected)
- Tuple inputs
```

### 4.2 Country-Specific Edge Cases

```elixir
# Special characteristics
- NO (Norway): Shortest IBAN (15 chars)
- MT (Malta): Longest IBAN (31 chars)
- BR (Brazil): Uses letters in account number
- Countries with optional fields (branch_code, national_check)

# BBAN part validation per country
- Bank code format and ranges
- Account number format and ranges
- Branch code presence/absence
- National check digit algorithms
- Minimum/maximum values for numeric parts
- Alpha/numeric/alphanumeric field types
```

### 4.3 Checksum Edge Cases

```elixir
# Algorithmic edge cases
- Valid checksums: 02-96, 98
- Algorithmically invalid: 01, 00, 97, 99
- Check digits as letters (should fail)
- Single digit check digits
- Missing check digits

# BBAN composition
- All-numeric BBANs
- All-alphabetic BBANs (e.g., QA)
- Mixed alphanumeric BBANs
- Maximum letter density (QA: "QAAA")
```

---

## 5. Property-Based Testing Opportunities

### 5.1 Recommended Properties (Using StreamData)

```elixir
# Invariants to test:

1. Round-trip preservation:
   valid_iban |> parse |> format(:compact) |> parse == valid_iban

2. Checksum determinism:
   iban_violates_checksum?(iban) == iban_violates_checksum?(iban)

3. Country code extraction:
   country_code(iban) always returns 2 uppercase characters

4. BBAN length:
   byte_size(bban(iban)) == size(country) - 4

5. Normalization idempotence:
   normalize(normalize(x)) == normalize(x)

6. Format preservation:
   format(parse(iban), :compact) preserves check digits

7. Serialization idempotence:
   to_map(from_map(map)) == map (for valid maps)

# Generators needed:
- Valid IBAN generator (per country, respecting rules)
- Invalid IBAN generator (various violation types)
- Edge case generator (boundary lengths, special chars)
- Mutation generator (valid IBAN with single-bit errors)
```

---

## 6. Test Data Management Strategy

### 6.1 Test Data Organization

```
test/support/
├── fixtures/
│   ├── valid_ibans.exs        # 200+ valid IBANs (3-5 per country)
│   ├── invalid_ibans.exs      # 500+ invalid IBANs by violation type
│   └── edge_cases.exs         # 100+ boundary cases
├── factories/
│   └── iban_factory.ex        # Build Iban structs with overrides
└── countries/
    └── country_test_suite.ex  # Shared country conformance tests
```

### 6.2 Test Data Sets Needed

```elixir
# 1. Valid IBANs Dataset (200+ entries)
# Organized by country, 3-5 per country
%{
  de: [
    "DE89370400440532013000",
    "DE44500105175407324931",
    # ... 3 more
  ],
  fr: [
    "FR1420041010050500013M02606",
    "FR7630006000011234567890189",
    # ... 3 more
  ],
  # ... all 70+ countries
}

# 2. Invalid IBANs Dataset (500+ entries)
# Organized by violation type
%{
  wrong_checksum: [
    "DE89370400440532013001",  # Valid format, wrong checksum
    "FR1420041010050500013M02607",
    # ... 100+ more
  ],
  wrong_length: [
    "DE8937040044053201300",   # Too short
    "DE893704004405320130000",  # Too long
    # ... 100+ more
  ],
  invalid_format: [
    "DEXXX70400440532013000",   # Invalid chars in BBAN
    "de89370400440532013000",   # Lowercase (should fail after normalize)
    # ... 100+ more
  ],
  unsupported_country: [
    "XX8937040044053201300",
    "ZZ1234567890123456",
    # ... 50+ more
  ],
  invalid_bank_code: [...],
  invalid_account_number: [...],
  invalid_branch_code: [...],
  invalid_national_check: [...],
}

# 3. Edge Cases Dataset (100+ entries)
%{
  shortest: "NO9386011117947",        # Norway: 15 chars
  longest: "MT84MALT011000012345MTLCAST001S", # Malta: 31 chars
  all_numeric_bban: [...],
  all_alpha_bban: [...],
  mixed_case: [...],
  with_spaces: [...],
  with_hyphens: [...],
  unicode: [...],
}
```

### 6.3 Test Support Modules

```elixir
# test/support/test_data.ex
defmodule IbanEx.TestData do
  @valid_ibans ... # load from fixtures/valid_ibans.exs
  @invalid_ibans ... # load from fixtures/invalid_ibans.exs
  @edge_cases ... # load from fixtures/edge_cases.exs
  
  def valid_ibans(country \\ :all) do
    case country do
      :all -> @valid_ibans |> Map.values() |> List.flatten()
      code -> Map.get(@valid_ibans, code, [])
    end
  end
  
  def invalid_ibans(violation_type \\ :all) do
    case violation_type do
      :all -> @invalid_ibans |> Map.values() |> List.flatten()
      type -> Map.get(@invalid_ibans, type, [])
    end
  end
  
  def edge_cases, do: @edge_cases
  
  def random_valid_iban, do: Enum.random(valid_ibans())
  def random_invalid_iban, do: Enum.random(invalid_ibans())
end

# test/support/factories/iban_factory.ex
defmodule IbanEx.IbanFactory do
  @doc "Build valid Iban struct with optional overrides"
  def build(attrs \\ %{}) do
    default = %IbanEx.Iban{
      country_code: "DE",
      check_digits: "89",
      bban: "370400440532013000",
      bank_code: "37040044",
      account_number: "0532013000",
      branch_code: nil,
      national_check: nil
    }
    
    struct!(default, attrs)
  end
  
  def build_with_invalid_checksum(attrs \\ %{}) do
    build(Map.put(attrs, :check_digits, "00"))
  end
end
```

---

## 7. Implementation Roadmap

### Phase 1: Critical Coverage (Weeks 1-2)
**Priority:** 🔴 **CRITICAL** - Security and data safety

**Focus:** Core validation, data conversion, parser safety

#### Week 1 Deliverables
1. ✅ **Validator Tests** (`test/iban_ex_validator_test.exs` expansion)
   - `violations/1` complete coverage (~100 lines)
   - `validate/1` all error paths (~80 lines)
   - `iban_violates_checksum?/1` comprehensive tests (~120 lines)
   - BBAN component validators negative tests (~150 lines)

2. ✅ **Deserialize Protocol Tests** (`test/iban_ex_deserialize_test.exs` - NEW)
   - String/BitString implementation (~80 lines)
   - Map implementation (atom keys) (~100 lines)
   - Map implementation (string keys) (~60 lines)
   - Keyword list implementation (~50 lines)
   - Error handling (~40 lines)

#### Week 2 Deliverables
3. ✅ **Parser Edge Cases** (`test/iban_ex_parser_test.exs` expansion)
   - `parse/2` edge cases (~150 lines)
   - `parse/2` with `incomplete: true` (~100 lines)
   - `parse_bban/3` tests (~80 lines)
   - Helper functions edge cases (~70 lines)

4. ✅ **Serialize Tests** (`test/iban_ex_serialize_test.exs` - NEW)
   - `to_string/1` tests (~60 lines)
   - `to_map/1` tests (~60 lines)
   - Round-trip tests (~50 lines)

**Estimated Lines of Test Code:** ~1,200 lines  
**Expected Coverage Increase:** 40% → 70%

---

### Phase 2: High Priority Coverage (Weeks 3-4)
**Priority:** 🟡 **HIGH** - User-facing APIs and utilities

#### Week 3 Deliverables
5. ✅ **Formatter Tests** (`test/iban_ex_formatter_test.exs` - NEW)
   - `available_formats/0` (~20 lines)
   - `format/2` all types (~120 lines)
   - Convenience functions (~60 lines)
   - Edge cases (~80 lines)
   - Round-trip preservation (~40 lines)

6. ✅ **Iban Struct Tests** (`test/iban_ex_iban_test.exs` - NEW)
   - Struct creation and validation (~80 lines)
   - Delegated functions (~100 lines)
   - Pattern matching (~40 lines)

7. ✅ **Commons Tests** (`test/iban_ex_commons_test.exs` - NEW)
   - `blank/1` (~40 lines)
   - `normalize/1` (~80 lines)
   - `normalize_and_slice/2` (~60 lines)

#### Week 4 Deliverables
8. ✅ **Country Module Tests** (`test/iban_ex_country_test.exs` - NEW)
   - Discovery functions (~100 lines)
   - Edge cases for lookup (~80 lines)

9. ✅ **Integration Tests** (`test/integration/` - NEW directory)
   - End-to-end workflows (~200 lines)
   - Cross-module integration (~150 lines)
   - Real-world scenarios (~100 lines)

10. ✅ **Test Infrastructure**
    - Fixtures: `test/support/fixtures/*.exs` (~300 lines)
    - Factory: `test/support/factories/iban_factory.ex` (~100 lines)
    - TestData: `test/support/test_data.ex` (~150 lines)

**Estimated Lines of Test Code:** ~1,700 lines  
**Expected Coverage Increase:** 70% → 85%

---

### Phase 3: Comprehensive Coverage (Weeks 5-6)
**Priority:** 🟢 **MEDIUM** - Country modules and regression

#### Week 5 Deliverables
11. ✅ **Country Implementation Tests** (`test/country/` - NEW directory)
    - Shared country test suite (~200 lines)
    - High-priority country tests (~400 lines):
      - DE, FR, GB, IT, BR, NO, MT
    - Template validation (~100 lines)

12. ✅ **Error Module Tests** (`test/iban_ex_error_test.exs` - NEW)
    - All error atoms (~60 lines)
    - Message consistency (~40 lines)
    - Fallback behavior (~20 lines)

#### Week 6 Deliverables
13. ✅ **Validator Replacements Tests** (`test/iban_ex_validator_replacements_test.exs` - NEW)
    - `replace/1` letter mapping (~100 lines)
    - Complete A-Z coverage (~50 lines)
    - Fallback behavior (~30 lines)

14. ✅ **Comprehensive Country Coverage**
    - Apply shared test suite to all 70+ countries (~100 lines)
    - Ensure async: true for performance

15. ✅ **Regression Test Suite** (`test/regression/` - NEW directory)
    - Violation type regression (~150 lines)
    - Known bug scenarios (~100 lines)

**Estimated Lines of Test Code:** ~1,350 lines  
**Expected Coverage Increase:** 85% → 92%

---

### Phase 4: Polish & Performance (Weeks 7-8)
**Priority:** 🟢 **NICE-TO-HAVE** - Property tests and performance

#### Week 7 Deliverables
16. ✅ **Property-Based Tests** (`test/property/iban_properties_test.exs` - NEW)
    - Round-trip invariants (~100 lines)
    - Checksum determinism (~60 lines)
    - Normalization idempotence (~60 lines)
    - Format preservation (~60 lines)
    - Generators (~150 lines)

17. ✅ **Performance Tests** (`test/performance/benchmarks_test.exs` - NEW)
    - Validation performance (~80 lines)
    - Parsing performance (~60 lines)
    - Bulk operations (~100 lines)

#### Week 8 Deliverables
18. ✅ **Documentation Enhancement**
    - README examples expansion
    - Module documentation examples
    - Error handling examples

19. ✅ **CI/CD Integration**
    - Coverage reporting setup (ExCoveralls)
    - Coverage gates configuration
    - Performance regression tests

20. ✅ **Final Audit**
    - Code coverage report generation
    - Identify remaining gaps
    - Document coverage achievements

**Estimated Lines of Test Code:** ~670 lines  
**Expected Coverage Increase:** 92% → 95%+

---

## 8. Recommended Test File Structure

```
test/
├── iban_ex_test.exs                    # Existing - doctests
├── iban_ex_parser_test.exs             # Existing - expand
├── iban_ex_validator_test.exs          # Existing - expand
├── iban_ex_formatter_test.exs          # NEW - Phase 2
├── iban_ex_iban_test.exs               # NEW - Phase 2
├── iban_ex_serialize_test.exs          # NEW - Phase 1
├── iban_ex_deserialize_test.exs        # NEW - Phase 1
├── iban_ex_country_test.exs            # NEW - Phase 2
├── iban_ex_commons_test.exs            # NEW - Phase 2
├── iban_ex_error_test.exs              # NEW - Phase 3
├── iban_ex_validator_replacements_test.exs # NEW - Phase 3
├── integration/                         # NEW - Phase 2
│   ├── iban_lifecycle_test.exs
│   ├── cross_module_test.exs
│   └── real_world_scenarios_test.exs
├── country/                             # NEW - Phase 3
│   ├── country_test_suite.ex           # Shared suite
│   ├── de_test.exs
│   ├── fr_test.exs
│   ├── gb_test.exs
│   ├── it_test.exs
│   ├── br_test.exs
│   ├── no_test.exs
│   ├── mt_test.exs
│   └── ...
├── regression/                          # NEW - Phase 3
│   ├── violation_regression_test.exs
│   └── known_bugs_test.exs
├── property/                            # NEW - Phase 4
│   └── iban_properties_test.exs
├── performance/                         # NEW - Phase 4
│   └── benchmarks_test.exs
├── support/                             # NEW - Phase 2
│   ├── fixtures/
│   │   ├── valid_ibans.exs
│   │   ├── invalid_ibans.exs
│   │   └── edge_cases.exs
│   ├── factories/
│   │   └── iban_factory.ex
│   ├── countries/
│   │   └── country_test_suite.ex
│   └── test_data.ex
└── test_helper.exs                      # Existing
```

---

## 9. Testing Tools and Infrastructure

### 9.1 Recommended Dependencies

```elixir
# mix.exs
defp deps do
  [
    # Existing production dependencies
    {:req, "~> 0.5.0"},
    
    # Testing dependencies
    {:ex_unit, "~> 1.18", only: :test},                              # Built-in
    {:stream_data, "~> 1.1", only: :test},                           # Property-based testing
    {:excoveralls, "~> 0.18", only: :test},                          # Coverage reporting
    {:benchee, "~> 1.3", only: [:dev, :test]},                       # Performance benchmarking
    {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},         # Auto-test on file change
    
    # Code quality (already available via mix check)
    {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},      # Type checking
    {:credo, "~> 1.7", only: [:dev, :test], runtime: false},         # Code quality
    {:ex_doc, "~> 0.34", only: :dev, runtime: false},                # Documentation
  ]
end
```

### 9.2 CI/CD Integration

```yaml
# .github/workflows/ci.yml (example)
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Elixir
        uses: erlef/setup-beam@v1
        with:
          elixir-version: '1.18'
          otp-version: '27'
      
      - name: Restore dependencies cache
        uses: actions/cache@v4
        with:
          path: deps
          key: ${{ runner.os }}-mix-${{ hashFiles('**/mix.lock') }}
          restore-keys: ${{ runner.os }}-mix-
      
      - name: Install dependencies
        run: mix deps.get
      
      - name: Run tests with coverage
        run: mix coveralls.json
        env:
          MIX_ENV: test
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: ./cover/excoveralls.json
          fail_ci_if_error: true
      
      - name: Run code quality checks
        run: mix check
      
      - name: Check coverage threshold
        run: |
          COVERAGE=$(jq '.total' ./cover/excoveralls.json)
          if (( $(echo "$COVERAGE < 90" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 90% threshold"
            exit 1
          fi
```

### 9.3 Coverage Configuration

```elixir
# mix.exs
def project do
  [
    # ...
    test_coverage: [tool: ExCoveralls],
    preferred_cli_env: [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.json": :test
    ],
  ]
end
```

### 9.4 Test Helper Configuration

```elixir
# test/test_helper.exs
ExUnit.start()

# Configure test output
ExUnit.configure(
  exclude: [slow: true],           # Exclude slow tests by default
  formatters: [ExUnit.CLIFormatter],
  max_cases: System.schedulers_online() * 2,  # Parallel test execution
  timeout: 60_000                   # 60s timeout for long tests
)

# Load test support files
Code.require_file("support/test_data.ex", __DIR__)
Code.require_file("support/factories/iban_factory.ex", __DIR__)

# Seed random number generator for consistent property tests
:rand.seed(:exsss, {1, 2, 3})
```

---

## 10. Quality Metrics and Success Criteria

### 10.1 Coverage Targets

| Phase | Line Coverage | Branch Coverage | Function Coverage |
|-------|---------------|-----------------|-------------------|
| **Current** | ~40-50% | ~30-40% | ~35-45% |
| **Phase 1** | 70% | 60% | 75% |
| **Phase 2** | 85% | 75% | 90% |
| **Phase 3** | 92% | 85% | 95% |
| **Phase 4** | 95%+ | 90%+ | 98%+ |

### 10.2 Quality Gates

```yaml
# Required for all PRs
minimum_coverage: 90%
coverage_regression_tolerance: -1%  # Max allowed decrease
test_execution_time: < 5 minutes
zero_test_failures: true
dialyzer_warnings: 0
credo_warnings: 0

# Required for releases
minimum_coverage: 95%
property_tests_passing: true
performance_benchmarks: no regression
documentation_coverage: 100%
```

### 10.3 Success Metrics

**Short-term (1 month - End of Phase 2):**
- ✅ All Phase 1 & 2 tests implemented
- ✅ Coverage ≥ 85%
- ✅ No untested critical functions (`violations/1`, `validate/1`, `iban_violates_checksum?/1`)
- ✅ All serialization/deserialization paths tested
- ✅ Integration tests operational

**Medium-term (3 months - End of Phase 4):**
- ✅ All phases completed
- ✅ Coverage ≥ 95%
- ✅ Property tests catching edge cases
- ✅ CI/CD integration with coverage gates
- ✅ Performance benchmarks established
- ✅ Zero production bugs from untested code paths

**Long-term (6 months):**
- ✅ Coverage maintained at 95%+
- ✅ < 5 minute test suite execution
- ✅ Quarterly test audits performed
- ✅ All new features have tests before merge
- ✅ Comprehensive documentation with examples

---

## 11. Appendix A: Example Test Implementations

### Example 1: Validator.violations/1 Complete Test

```elixir
# test/iban_ex_validator_test.exs (expansion)

describe "violations/1" do
  test "returns empty list for valid IBAN" do
    valid_ibans = IbanEx.TestData.valid_ibans()
    
    for iban <- valid_ibans do
      assert Validator.violations(iban) == [],
             "Expected no violations for valid IBAN: #{iban}"
    end
  end

  test "returns all violations for completely invalid IBAN" do
    violations = Validator.violations("INVALID")
    
    # Should have multiple violations
    assert :invalid_format in violations
    assert :unsupported_country_code in violations
    assert :invalid_length in violations
    
    # Should be deterministic
    assert violations == Validator.violations("INVALID")
  end

  test "returns specific violations for IBAN with wrong checksum" do
    # Valid format but wrong checksum (00 is algorithmically invalid)
    violations = Validator.violations("DE00370400440532013000")
    
    assert :invalid_checksum in violations
    refute :invalid_format in violations
    refute :unsupported_country_code in violations
  end

  test "returns multiple BBAN violations" do
    # Create IBAN with invalid BBAN structure
    violations = Validator.violations("DE89XXXXXXXXXXXX0000")
    
    # Should include BBAN format violations
    assert length(violations) > 0
    # Specific violations depend on DE country rules
  end
  
  test "returns violations for wrong length" do
    # German IBAN should be 22 chars, this is 21
    violations = Validator.violations("DE8937040044053201300")
    
    assert :invalid_length in violations
  end
  
  test "violations are deterministically ordered" do
    iban = "INVALID"
    violations1 = Validator.violations(iban)
    violations2 = Validator.violations(iban)
    
    assert violations1 == violations2
  end
end
```

### Example 2: Deserialize Protocol Complete Test

```elixir
# test/iban_ex_deserialize_test.exs (NEW)

defmodule IbanEx.DeserializeTest do
  use ExUnit.Case, async: true
  
  alias IbanEx.{Deserialize, Iban}

  describe "Deserialize.from/1 - String implementation" do
    test "deserializes valid IBAN string" do
      iban_string = "DE89370400440532013000"
      
      assert {:ok, %Iban{} = iban} = Deserialize.from(iban_string)
      assert iban.country_code == "DE"
      assert iban.check_digits == "89"
      assert iban.bban == "370400440532013000"
    end
    
    test "returns error for invalid IBAN string" do
      assert {:error, _reason} = Deserialize.from("INVALID")
    end
    
    test "handles empty string" do
      assert {:error, _reason} = Deserialize.from("")
    end
    
    test "handles bitstring input" do
      bitstring = <<"DE89370400440532013000">>
      
      assert {:ok, %Iban{}} = Deserialize.from(bitstring)
    end
  end

  describe "Deserialize.from/1 - Map implementation (atom keys)" do
    test "deserializes valid map with all required fields" do
      map = %{
        country_code: "DE",
        check_digits: "89",
        bban: "370400440532013000",
        bank_code: "37040044",
        account_number: "0532013000",
        branch_code: nil,
        national_check: nil
      }
      
      assert {:ok, %Iban{} = iban} = Deserialize.from(map)
      assert iban.country_code == "DE"
      assert iban.check_digits == "89"
    end
    
    test "deserializes map with optional fields as nil" do
      map = %{
        country_code: "DE",
        check_digits: "89",
        bban: "370400440532013000",
        bank_code: "37040044",
        account_number: "0532013000"
        # branch_code and national_check missing
      }
      
      assert {:ok, %Iban{} = iban} = Deserialize.from(map)
      assert iban.branch_code == nil
      assert iban.national_check == nil
    end
    
    test "returns error for map missing required fields" do
      map = %{
        country_code: "DE"
        # Missing other required fields
      }
      
      assert {:error, {:can_not_parse_map, _}} = Deserialize.from(map)
    end
    
    test "handles map with extra fields" do
      map = %{
        country_code: "DE",
        check_digits: "89",
        bban: "370400440532013000",
        bank_code: "37040044",
        account_number: "0532013000",
        extra_field: "should be ignored"
      }
      
      assert {:ok, %Iban{}} = Deserialize.from(map)
    end
  end

  describe "Deserialize.from/1 - Map implementation (string keys)" do
    test "deserializes map with string keys" do
      map = %{
        "country_code" => "DE",
        "check_digits" => "89",
        "bban" => "370400440532013000",
        "bank_code" => "37040044",
        "account_number" => "0532013000"
      }
      
      assert {:ok, %Iban{} = iban} = Deserialize.from(map)
      assert iban.country_code == "DE"
    end
    
    test "handles mixed atom and string keys" do
      map = %{
        "country_code" => "DE",
        check_digits: "89",  # atom key
        "bban" => "370400440532013000"
      }
      
      # Behavior depends on implementation
      # Should either work or return consistent error
      result = Deserialize.from(map)
      assert match?({:ok, _} | {:error, _}, result)
    end
  end

  describe "Deserialize.from/1 - Keyword list implementation" do
    test "deserializes valid keyword list" do
      list = [
        country_code: "DE",
        check_digits: "89",
        bban: "370400440532013000",
        bank_code: "37040044",
        account_number: "0532013000"
      ]
      
      assert {:ok, %Iban{}} = Deserialize.from(list)
    end
    
    test "returns error for empty list" do
      assert {:error, _} = Deserialize.from([])
    end
  end

  describe "Deserialize.from/1 - Error handling" do
    test "protocol not implemented for integers" do
      assert_raise Protocol.UndefinedError, fn ->
        Deserialize.from(12345)
      end
    end
    
    test "protocol not implemented for atoms" do
      assert_raise Protocol.UndefinedError, fn ->
        Deserialize.from(:invalid)
      end
    end
  end
end
```

### Example 3: Property-Based Test

```elixir
# test/property/iban_properties_test.exs (NEW)

defmodule IbanEx.PropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IbanEx.{Parser, Formatter, Validator, Commons}

  @tag :property
  property "valid IBAN round-trips through parse and format" do
    check all iban_string <- valid_iban_generator() do
      {:ok, iban} = Parser.parse(iban_string)
      formatted = Formatter.format(iban, :compact)
      {:ok, reparsed} = Parser.parse(formatted)
      
      assert iban == reparsed,
             "Round-trip failed: #{iban_string} -> #{formatted}"
    end
  end

  @tag :property
  property "checksum validation is deterministic" do
    check all iban_string <- StreamData.string(:alphanumeric, min_length: 15, max_length: 34) do
      result1 = Validator.iban_violates_checksum?(iban_string)
      result2 = Validator.iban_violates_checksum?(iban_string)
      
      assert result1 == result2,
             "Checksum validation non-deterministic for: #{iban_string}"
    end
  end

  @tag :property
  property "country_code always returns 2 uppercase chars for normalized input" do
    check all iban_string <- StreamData.string(:alphanumeric, min_length: 15, max_length: 34) do
      normalized = Commons.normalize(iban_string)
      
      if byte_size(normalized) >= 2 do
        code = Parser.country_code(normalized)
        assert byte_size(code) == 2
        assert code == String.upcase(code)
      end
    end
  end

  @tag :property
  property "normalization is idempotent" do
    check all input <- StreamData.string(:printable) do
      normalized_once = Commons.normalize(input)
      normalized_twice = Commons.normalize(normalized_once)
      
      assert normalized_once == normalized_twice,
             "Normalization not idempotent for: #{inspect(input)}"
    end
  end

  @tag :property
  property "formatting preserves check digits" do
    check all iban_string <- valid_iban_generator(),
              format <- StreamData.member_of([:compact, :pretty, :splitted]) do
      {:ok, iban} = Parser.parse(iban_string)
      formatted = Formatter.format(iban, format)
      {:ok, reparsed} = Parser.parse(formatted)
      
      assert iban.check_digits == reparsed.check_digits,
             "Format #{format} altered check digits: #{iban_string}"
    end
  end

  # Generators
  
  defp valid_iban_generator do
    # Use test fixtures as base
    IbanEx.TestData.valid_ibans()
    |> StreamData.member_of()
  end
  
  defp invalid_iban_generator do
    # Generate invalid IBANs by mutating valid ones
    gen all iban <- valid_iban_generator(),
            mutation <- mutation_generator() do
      apply_mutation(iban, mutation)
    end
  end
  
  defp mutation_generator do
    StreamData.member_of([
      :flip_checksum,
      :change_length,
      :invalid_char,
      :wrong_country
    ])
  end
  
  defp apply_mutation(iban, :flip_checksum) do
    # Flip check digits to create invalid checksum
    <<country::binary-size(2), check::binary-size(2), rest::binary>> = iban
    flipped = if check == "00", do: "01", else: "00"
    country <> flipped <> rest
  end
  
  defp apply_mutation(iban, :change_length) do
    # Add or remove character
    if :rand.uniform(2) == 1 do
      iban <> "0"
    else
      String.slice(iban, 0..-2//1)
    end
  end
  
  defp apply_mutation(iban, :invalid_char) do
    # Insert invalid character
    pos = :rand.uniform(byte_size(iban)) - 1
    <<before::binary-size(pos), _::binary-size(1), after_::binary>> = iban
    before <> "!" <> after_
  end
  
  defp apply_mutation(iban, :wrong_country) do
    # Replace with unsupported country
    <<"XX", rest::binary>> = String.slice(iban, 2..-1//1)
    "XX" <> rest
  end
end
```

---

## 12. Monitoring and Maintenance

### 12.1 Ongoing Test Maintenance

**New Country Support:**
```elixir
# Template for adding new country tests
# test/country/{code}_test.exs

defmodule IbanEx.Country.XXTest do
  use ExUnit.Case, async: true
  use IbanEx.CountryTestSuite  # Shared suite
  
  @country_code "XX"
  @module IbanEx.Country.XX
  
  # Shared suite runs automatically:
  # - size/0 validation
  # - rules/0 and rules_map/0 consistency
  # - to_string/1 formatting
  # - BBAN regex validation
  
  # Add country-specific edge cases here
  test "XX-specific edge case" do
    # ...
  end
end
```

**Regression Prevention:**
```elixir
# For every bug fix, add to test/regression/known_bugs_test.exs

test "issue #42: checksum validation for all-letter BBANs" do
  # Reproduce the bug scenario
  # Assert it's now fixed
end
```

**Quarterly Audit Checklist:**
- [ ] Run `mix coveralls.html` and review uncovered lines
- [ ] Check for new untested public functions
- [ ] Review property test failure logs
- [ ] Update test data fixtures with new edge cases
- [ ] Benchmark test suite execution time
- [ ] Update CI/CD coverage thresholds if needed

### 12.2 Code Review Process

**PR Test Requirements:**
- All new functions must have tests in same PR
- Coverage must not decrease (enforced by CI)
- Property tests for new algorithms
- Integration tests for cross-module changes
- Documentation examples must have doctests

---

## 13. Summary and Next Steps

### 13.1 Immediate Actions (This Week)

1. ✅ **Set up coverage tooling**
   ```bash
   # Add to mix.exs
   {:excoveralls, "~> 0.18", only: :test}
   
   # Run baseline
   mix coveralls.html
   ```

2. ✅ **Create test infrastructure**
   ```bash
   mkdir -p test/support/fixtures
   mkdir -p test/support/factories
   touch test/support/test_data.ex
   touch test/support/factories/iban_factory.ex
   ```

3. ✅ **Implement Phase 1, Priority 1-2**
   - `test/iban_ex_validator_test.exs`: Add `violations/1` and `validate/1` tests
   - `test/iban_ex_deserialize_test.exs`: NEW file with protocol tests

4. ✅ **Baseline measurement**
   ```bash
   mix test --cover
   mix coveralls.detail
   # Document current coverage
   ```

### 13.2 Success Criteria Summary

| Timeframe | Goal | Coverage Target | Key Deliverables |
|-----------|------|-----------------|------------------|
| **Week 2** | Phase 1 Complete | 70% | Critical validators, deserialize, parser safety |
| **Week 4** | Phase 2 Complete | 85% | Formatter, integration, test infrastructure |
| **Week 6** | Phase 3 Complete | 92% | All countries, regression, utilities |
| **Week 8** | Phase 4 Complete | 95%+ | Properties, performance, CI/CD |

### 13.3 Long-Term Vision

**6 Months:**
- **Zero production bugs** from untested code paths
- **< 5 minute** test suite execution time
- **95%+** code coverage maintained automatically
- **All public APIs** have documented examples with doctests
- **Property tests** catch edge cases before manual testing
- **Performance benchmarks** prevent regression
- **Automated coverage gates** in CI/CD prevent coverage decrease

**12 Months:**
- **Test-driven development** culture for all changes
- **Comprehensive test data** covering all IBAN edge cases globally
- **Mutation testing** to verify test suite quality
- **Automated security** scanning for IBAN handling vulnerabilities
- **Performance monitoring** tracking validation latency over time

---

## Appendix B: Coverage Report Template

```markdown
# Coverage Report - [Date]

## Overall Metrics
- **Line Coverage:** X%
- **Branch Coverage:** Y%
- **Function Coverage:** Z%
- **Test Execution Time:** X.XXs

## Module Breakdown
| Module | Line % | Branch % | Function % | Status |
|--------|--------|----------|------------|--------|
| IbanEx | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Parser | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Validator | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Formatter | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Iban | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Serialize | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Deserialize | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Country | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Commons | X% | Y% | Z% | ✅/⚠️/❌ |
| IbanEx.Error | X% | Y% | Z% | ✅/⚠️/❌ |

## Uncovered Critical Paths
1. **[Module].[Function]:** [Reason not covered / Plan to cover]
2. ...

## Test Suite Statistics
- **Total Tests:** X
- **Total Assertions:** Y
- **Property Tests:** Z
- **Test Files:** N

## Next Phase Target
- **Target Completion:** [Date]
- **Expected Coverage Increase:** +X%
- **Focus Areas:**
  - [ ] Module A
  - [ ] Module B
  - [ ] Integration scenarios

## Notable Improvements This Phase
- Added X tests covering Y functions
- Improved coverage from A% to B%
- Discovered and fixed Z edge cases
```

---

**Document Version:** 2.0 (Merged & Enhanced)  
**Created:** 2025-01-29  
**Last Updated:** 2025-01-29  
**Authors:** Comprehensive analysis combining multiple perspectives  
**Tooling Used:** Tree Sitter, Cicada MCP, Manual Source Review

---

## Quick Reference: Priority Matrix

| Priority | Modules | Why Critical | When to Implement |
|----------|---------|--------------|-------------------|
| 🔴 **CRITICAL** | Validator (`violations/1`, `validate/1`, checksum), Deserialize, Parser edge cases | Security, data safety, silent failures | **Week 1-2** (Phase 1) |
| 🟡 **HIGH** | Formatter, Serialize, Iban struct, Commons, Country lookup | User-facing APIs, utilities | **Week 3-4** (Phase 2) |
| 🟢 **MEDIUM** | Country implementations, Error, Replacements, Regression | Comprehensive coverage, edge cases | **Week 5-6** (Phase 3) |
| 🟢 **NICE** | Property tests, Performance, Documentation | Polish, optimization, prevention | **Week 7-8** (Phase 4) |

**Remember:** The goal is not just coverage percentage, but **confidence that every code path behaves correctly under all conditions**.
