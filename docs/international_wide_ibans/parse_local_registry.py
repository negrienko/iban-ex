#!/usr/bin/env python3
"""
Parse IBAN Registry from local TXT file to create comprehensive test fixtures.
This is the single source of truth for IBAN validation rules.
"""

import json
import re

COUNTRY_CODE_PATTERN = r"[A-Z]{2}"
EMPTY_RANGE = (0, 0)


def parse_int(raw):
    """Extract first integer from string."""
    if not raw or raw == "N/A":
        return 0
    match = re.search(r"\d+", raw)
    return int(match.group()) if match else 0


def parse_range(raw):
    """Parse position range like '1-4' to zero-indexed tuple (0, 4)."""
    if not raw or raw == "N/A" or raw.strip() == "":
        return EMPTY_RANGE
    pattern = r".*?(?P<from>\d+)\s*-\s*(?P<to>\d+)"
    match = re.search(pattern, raw)
    if not match:
        return EMPTY_RANGE
    # Convert to zero-indexed: position 1-4 becomes (0, 4)
    return (int(match["from"]) - 1, int(match["to"]))


def parse_registry(filepath):
    """Parse the SWIFT IBAN Registry TXT file."""
    with open(filepath, "r", encoding="latin1") as f:
        lines = f.readlines()

    # Parse line by line
    data = {}
    for line in lines:
        parts = line.rstrip("\r\n").split("\t")
        if len(parts) < 2:
            continue

        header = parts[0].strip()
        values = [p.strip() for p in parts[1:]]

        if header:
            data[header] = values

    # Build records from columns
    if "IBAN prefix country code (ISO 3166)" not in data:
        raise ValueError("Could not find country code row")

    num_countries = len(data["IBAN prefix country code (ISO 3166)"])
    records = []

    for i in range(num_countries):
        record = {}

        # Extract data for each column
        for header, values in data.items():
            if i < len(values):
                record[header] = values[i]
            else:
                record[header] = ""

        records.append(record)

    return records


def process_positions(record):
    """Process position information for bank code, branch code, and account number."""
    bank_code = parse_range(record.get("Bank identifier position within the BBAN", ""))
    branch_code = parse_range(
        record.get("Branch identifier position within the BBAN", "")
    )
    bban_length = parse_int(record.get("BBAN length", "0"))

    # If no branch code, set it to end of bank code
    if branch_code == EMPTY_RANGE:
        branch_code = (bank_code[1], bank_code[1])

    # Account code starts after bank and branch codes
    account_start = max(bank_code[1], branch_code[1])

    return {
        "bank_code": {
            "start": bank_code[0],
            "end": bank_code[1],
            "pattern": record.get("Bank identifier pattern", ""),
            "example": record.get("Bank identifier example", ""),
        },
        "branch_code": {
            "start": branch_code[0],
            "end": branch_code[1],
            "pattern": record.get("Branch identifier pattern", ""),
            "example": record.get("Branch identifier example", ""),
        },
        "account_code": {
            "start": account_start,
            "end": bban_length,
            "example": record.get("Domestic account number example", ""),
        },
    }


def parse_other_territories(value):
    """Parse other territories from string."""
    if not value or value == "N/A":
        return []
    # Extract all country codes
    return re.findall(COUNTRY_CODE_PATTERN, value)


def process_registry(records):
    """Process raw records into structured registry."""
    registry = {}

    for record in records:
        country_code_raw = record.get("IBAN prefix country code (ISO 3166)", "")
        if not country_code_raw:
            continue

        # Extract country code
        match = re.search(COUNTRY_CODE_PATTERN, country_code_raw)
        if not match:
            continue

        country_code = match.group()

        # Parse SEPA status
        sepa = record.get("SEPA country", "").strip().lower() == "yes"

        # Parse other territories
        other_territories = parse_other_territories(
            record.get("Country code includes other countries/territories", "")
        )

        # Build registry entry
        entry = {
            "country_name": record.get("Name of country", ""),
            "country_code": country_code,
            "sepa_country": sepa,
            "bban": {
                "spec": record.get("BBAN structure", ""),
                "length": parse_int(record.get("BBAN length", "0")),
                "example": record.get("BBAN example", ""),
            },
            "iban": {
                "spec": record.get("IBAN structure", ""),
                "length": parse_int(record.get("IBAN length", "0")),
                "example_electronic": record.get("IBAN electronic format example", ""),
                "example_print": record.get("IBAN print format example", ""),
            },
            "positions": process_positions(record),
            "effective_date": record.get("Effective date", ""),
            "other_territories": other_territories,
        }

        registry[country_code] = entry

        # Also register other territories under the same rules
        for territory_code in other_territories:
            if territory_code and territory_code not in registry:
                registry[territory_code] = {
                    **entry,
                    "country_code": territory_code,
                    "parent_country": country_code,
                }

    return registry


def generate_test_fixtures(registry):
    """Generate test fixtures for validation."""
    fixtures = {
        "valid_ibans": {},
        "country_specs": {},
        "metadata": {
            "total_countries": len(registry),
            "sepa_countries": sum(
                1 for c in registry.values() if c.get("sepa_country")
            ),
            "source": "SWIFT IBAN Registry",
            "format_version": "TXT Release 100",
        },
    }

    for code, entry in sorted(registry.items()):
        # Valid IBAN examples
        if entry["iban"]["example_electronic"]:
            fixtures["valid_ibans"][code] = {
                "electronic": entry["iban"]["example_electronic"],
                "print": entry["iban"]["example_print"],
                "country_name": entry["country_name"],
            }

        # Country specifications
        fixtures["country_specs"][code] = {
            "country_name": entry["country_name"],
            "iban_length": entry["iban"]["length"],
            "bban_length": entry["bban"]["length"],
            "iban_spec": entry["iban"]["spec"],
            "bban_spec": entry["bban"]["spec"],
            "sepa": entry["sepa_country"],
            "positions": entry["positions"],
            "effective_date": entry["effective_date"],
        }

    return fixtures


if __name__ == "__main__":
    print("Parsing IBAN Registry from local file...")

    # Parse the registry
    records = parse_registry("iban-registry-100.txt")
    print(f"✓ Parsed {len(records)} records")

    # Process into structured format
    registry = process_registry(records)
    print(f"✓ Processed {len(registry)} country codes")

    # Generate test fixtures
    fixtures = generate_test_fixtures(registry)
    print(f"✓ Generated fixtures for {len(fixtures['valid_ibans'])} countries")
    print(f"✓ SEPA countries: {fixtures['metadata']['sepa_countries']}")

    # Save full registry
    with open("iban_registry_full.json", "w") as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)
    print("✓ Saved: iban_registry_full.json")

    # Save test fixtures
    with open("iban_test_fixtures.json", "w") as f:
        json.dump(fixtures, f, indent=2, ensure_ascii=False)
    print("✓ Saved: iban_test_fixtures.json")

    # Generate summary report
    print("\n" + "=" * 70)
    print("IBAN REGISTRY SUMMARY - SINGLE SOURCE OF TRUTH")
    print("=" * 70)
    print(f"Total countries/territories: {fixtures['metadata']['total_countries']}")
    print(f"SEPA countries: {fixtures['metadata']['sepa_countries']}")
    print(f"\nIBAN Length Distribution:")

    length_dist = {}
    for spec in fixtures["country_specs"].values():
        length = spec["iban_length"]
        if length > 0:
            length_dist[length] = length_dist.get(length, 0) + 1

    for length in sorted(length_dist.keys()):
        print(f"  {length:2d} chars: {length_dist[length]:2d} countries")

    if length_dist:
        print(f"\nShortest IBAN: {min(length_dist.keys())} characters")
        print(f"Longest IBAN: {max(length_dist.keys())} characters")

    # Show sample countries
    print(f"\nSample Countries (first 15):")
    print(f"{'Code':<5} {'Country Name':<35} {'Length':<7} {'SEPA':<6} {'Example'}")
    print("-" * 100)

    for code in sorted(list(fixtures["valid_ibans"].keys()))[:15]:
        entry = fixtures["country_specs"][code]
        iban_ex = fixtures["valid_ibans"][code]["electronic"][:30]
        print(
            f"{code:<5} {entry['country_name'][:35]:<35} {entry['iban_length']:<7} "
            f"{'Yes' if entry['sepa'] else 'No':<6} {iban_ex}"
        )

    # Show countries with special characteristics
    print(f"\nSpecial Characteristics:")

    # Find shortest and longest
    shortest_code = min(
        fixtures["country_specs"].items(),
        key=lambda x: x[1]["iban_length"] if x[1]["iban_length"] > 0 else 999,
    )
    longest_code = max(
        fixtures["country_specs"].items(), key=lambda x: x[1]["iban_length"]
    )

    print(
        f"  Shortest: {shortest_code[0]} ({shortest_code[1]['country_name']}) - "
        f"{shortest_code[1]['iban_length']} chars"
    )
    print(
        f"  Longest:  {longest_code[0]} ({longest_code[1]['country_name']}) - "
        f"{longest_code[1]['iban_length']} chars"
    )

    print("\n" + "=" * 70)
    print("✓ Processing complete! Use these files for testing:")
    print("  • iban_registry_full.json - Complete registry with all fields")
    print("  • iban_test_fixtures.json - Test fixtures for valid IBANs")
    print("=" * 70)
