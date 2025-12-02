defmodule Mix.Tasks.GenerateFixtures do
  @moduledoc """
  Generate test fixtures from IBAN examples.

  Usage:
      mix generate_fixtures
  """

  use Mix.Task

  @shortdoc "Generate test fixture data"

  # IBAN examples from SWIFT registry via wise.com
  @iban_examples %{
    "AD" => "AD1200012030200359100100",
    "AE" => "AE070331234567890123456",
    "AL" => "AL47212110090000000235698741",
    "AT" => "AT611904300234573201",
    "AX" => "FI2112345600000785",
    "AZ" => "AZ21NABZ00000000137010001944",
    "BA" => "BA391290079401028494",
    "BE" => "BE68539007547034",
    "BG" => "BG80BNBG96611020345678",
    "BH" => "BH67BMAG00001299123456",
    "BI" => "BI4210000100010000332045181",
    "BL" => "FR1420041010050500013M02606",
    "BR" => "BR1800360305000010009795493C1",
    "BY" => "BY13NBRB3600900000002Z00AB00",
    "CH" => "CH9300762011623852957",
    "CR" => "CR05015202001026284066",
    "CY" => "CY17002001280000001200527600",
    "CZ" => "CZ6508000000192000145399",
    "DE" => "DE89370400440532013000",
    "DJ" => "DJ2100010000000154000100186",
    "DK" => "DK5000400440116243",
    "DO" => "DO28BAGR00000001212453611324",
    "EE" => "EE382200221020145685",
    "EG" => "EG380019000500000000263180002",
    "ES" => "ES9121000418450200051332",
    "FI" => "FI2112345600000785",
    "FK" => "FK88SC123456789012",
    "FO" => "FO6264600001631634",
    "FR" => "FR1420041010050500013M02606",
    "GB" => "GB29NWBK60161331926819",
    "GE" => "GE29NB0000000101904917",
    "GF" => "FR1420041010050500013M02606",
    "GG" => "GB29NWBK60161331926819",
    "GI" => "GI75NWBK000000007099453",
    "GL" => "GL8964710001000206",
    "GP" => "FR1420041010050500013M02606",
    "GR" => "GR1601101250000000012300695",
    "GT" => "GT82TRAJ01020000001210029690",
    "HN" => "HN54PISA00000000000000123124",
    "HR" => "HR1210010051863000160",
    "HU" => "HU42117730161111101800000000",
    "IE" => "IE29AIBK93115212345678",
    "IL" => "IL620108000000099999999",
    "IM" => "GB29NWBK60161331926819",
    "IQ" => "IQ98NBIQ850123456789012",
    "IS" => "IS140159260076545510730339",
    "IT" => "IT60X0542811101000000123456",
    "JE" => "GB29NWBK60161331926819",
    "JO" => "JO94CBJO0010000000000131000302",
    "KW" => "KW81CBKU0000000000001234560101",
    "KZ" => "KZ86125KZT5004100100",
    "LB" => "LB62099900000001001901229114",
    "LC" => "LC55HEMM000100010012001200023015",
    "LI" => "LI21088100002324013AA",
    "LT" => "LT121000011101001000",
    "LU" => "LU280019400644750000",
    "LV" => "LV80BANK0000435195001",
    "LY" => "LY83002048000020100120361",
    "MC" => "MC5811222000010123456789030",
    "MD" => "MD24AG000225100013104168",
    "ME" => "ME25505000012345678951",
    "MF" => "FR1420041010050500013M02606",
    "MK" => "MK07250120000058984",
    "MN" => "MN121234123456789123",
    "MQ" => "FR1420041010050500013M02606",
    "MR" => "MR1300020001010000123456753",
    "MT" => "MT84MALT011000012345MTLCAST001S",
    "MU" => "MU17BOMM0101101030300200000MUR",
    "NC" => "FR1420041010050500013M02606",
    "NI" => "NI45BAPR00000013000003558124",
    "NL" => "NL91ABNA0417164300",
    "NO" => "NO9386011117947",
    "OM" => "OM810180000001299123456",
    "PF" => "FR1420041010050500013M02606",
    "PK" => "PK36SCBL0000001123456702",
    "PL" => "PL61109010140000071219812874",
    "PM" => "FR1420041010050500013M02606",
    "PS" => "PS92PALS000000000400123456702",
    "PT" => "PT50000201231234567890154",
    "QA" => "QA58DOHB00001234567890ABCDEFG",
    "RE" => "FR1420041010050500013M02606",
    "RO" => "RO49AAAA1B31007593840000",
    "RS" => "RS35260005601001611379",
    "RU" => "RU0204452560040702810412345678901",
    "SA" => "SA0380000000608010167519",
    "SC" => "SC18SSCB11010000000000001497USD",
    "SD" => "SD8811123456789012",
    "SE" => "SE4550000000058398257466",
    "SI" => "SI56263300012039086",
    "SK" => "SK3112000000198742637541",
    "SM" => "SM86U0322509800000000270100",
    "SO" => "SO211000001001000100141",
    "ST" => "ST68000100010051845310112",
    "SV" => "SV62CENR00000000000000700025",
    "TF" => "FR1420041010050500013M02606",
    "TL" => "TL380080012345678910157",
    "TN" => "TN5910006035183598478831",
    "TR" => "TR330006100519786457841326",
    "UA" => "UA213223130000026007233566001",
    "VA" => "VA59001123000012345678",
    "VG" => "VG96VPVG0000012345678901",
    "WF" => "FR1420041010050500013M02606",
    "XK" => "XK051212012345678906",
    "YE" => "YE31CBYE0001000000001234567890",
    "YT" => "FR1420041010050500013M02606"
  }

  @sepa_countries ~w[
    AT BE BG HR CY CZ DK EE FI FR DE GR HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE
    GB GI IS LI NO CH MC SM VA AD
    AX BL GF GP MF MQ NC PF PM RE TF WF YT
    GG IM JE
  ]

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    IO.puts("Generating test fixtures...")

    valid_ibans = generate_valid_ibans()
    country_specs = generate_country_specs()

    fixtures = %{
      "valid_ibans" => valid_ibans,
      "country_specs" => country_specs,
      "metadata" => generate_metadata(valid_ibans, country_specs)
    }

    json = JSON.encode!(fixtures)

    File.write!("test/support/iban_test_fixtures.json", json)

    IO.puts("✓ Generated test/support/iban_test_fixtures.json")
  end

  defp generate_valid_ibans do
    @iban_examples
    |> Enum.map(fn {code, iban} ->
      {code,
       %{
         "electronic" => iban,
         "print" => format_print(iban),
         "country_name" => country_name(code)
       }}
    end)
    |> Map.new()
  end

  defp generate_country_specs do
    @iban_examples
    |> Enum.map(fn {code, iban} ->
      case IbanEx.Parser.parse(iban) do
        {:ok, parsed} ->
          # Get BBAN and check if numeric only
          bban = String.slice(iban, 4..-1//1)
          numeric_only = String.match?(bban, ~r/^[0-9]+$/)

          iban_length = String.length(iban)
          bban_length = iban_length - 4
          # Use actual country code from parsed IBAN (e.g., FI for AX)
          actual_country_code = parsed.country_code

          spec = %{
            "country_name" => country_name(code),
            "iban_length" => iban_length,
            "bban_length" => bban_length,
            "bban_spec" => get_bban_spec(code),
            "iban_spec" => "#{actual_country_code}2!n#{bban_length}!c",
            "sepa" => code in @sepa_countries,
            "numeric_only" => numeric_only,
            "positions" => %{
              "bank_code" => get_positions(parsed.bank_code, iban),
              "branch_code" => get_positions(parsed.branch_code, iban),
              "account_number" => get_positions(parsed.account_number, iban),
              "national_check" => get_positions(parsed.national_check, iban)
            }
          }

          {code, spec}

        {:error, reason} ->
          IO.puts("Warning: Failed to parse #{code} IBAN: #{iban} - #{inspect(reason)}")
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  defp format_print(iban) do
    iban
    |> String.graphemes()
    |> Enum.chunk_every(4)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  defp country_name(code) do
    names = %{
      "AD" => "Andorra",
      "AE" => "United Arab Emirates",
      "AL" => "Albania",
      "AT" => "Austria",
      "AX" => "Åland Islands",
      "AZ" => "Azerbaijan",
      "BA" => "Bosnia and Herzegovina",
      "BE" => "Belgium",
      "BG" => "Bulgaria",
      "BH" => "Bahrain",
      "BI" => "Burundi",
      "BL" => "Saint Barthélemy",
      "BR" => "Brazil",
      "BY" => "Belarus",
      "CH" => "Switzerland",
      "CR" => "Costa Rica",
      "CY" => "Cyprus",
      "CZ" => "Czechia",
      "DE" => "Germany",
      "DJ" => "Djibouti",
      "DK" => "Denmark",
      "DO" => "Dominican Republic",
      "EE" => "Estonia",
      "EG" => "Egypt",
      "ES" => "Spain",
      "FI" => "Finland",
      "FK" => "Falkland Islands",
      "FO" => "Faroe Islands",
      "FR" => "France",
      "GB" => "United Kingdom",
      "GE" => "Georgia",
      "GF" => "French Guiana",
      "GG" => "Guernsey",
      "GI" => "Gibraltar",
      "GL" => "Greenland",
      "GP" => "Guadeloupe",
      "GR" => "Greece",
      "GT" => "Guatemala",
      "HN" => "Honduras",
      "HR" => "Croatia",
      "HU" => "Hungary",
      "IE" => "Ireland",
      "IL" => "Israel",
      "IM" => "Isle of Man",
      "IQ" => "Iraq",
      "IS" => "Iceland",
      "IT" => "Italy",
      "JE" => "Jersey",
      "JO" => "Jordan",
      "KW" => "Kuwait",
      "KZ" => "Kazakhstan",
      "LB" => "Lebanon",
      "LC" => "Saint Lucia",
      "LI" => "Liechtenstein",
      "LT" => "Lithuania",
      "LU" => "Luxembourg",
      "LV" => "Latvia",
      "LY" => "Libya",
      "MC" => "Monaco",
      "MD" => "Moldova",
      "ME" => "Montenegro",
      "MF" => "Saint Martin",
      "MK" => "North Macedonia",
      "MN" => "Mongolia",
      "MQ" => "Martinique",
      "MR" => "Mauritania",
      "MT" => "Malta",
      "MU" => "Mauritius",
      "NC" => "New Caledonia",
      "NI" => "Nicaragua",
      "NL" => "Netherlands",
      "NO" => "Norway",
      "OM" => "Oman",
      "PF" => "French Polynesia",
      "PK" => "Pakistan",
      "PL" => "Poland",
      "PM" => "Saint Pierre and Miquelon",
      "PS" => "Palestine",
      "PT" => "Portugal",
      "QA" => "Qatar",
      "RE" => "Réunion",
      "RO" => "Romania",
      "RS" => "Serbia",
      "RU" => "Russia",
      "SA" => "Saudi Arabia",
      "SC" => "Seychelles",
      "SD" => "Sudan",
      "SE" => "Sweden",
      "SI" => "Slovenia",
      "SK" => "Slovakia",
      "SM" => "San Marino",
      "SO" => "Somalia",
      "ST" => "São Tomé and Príncipe",
      "SV" => "El Salvador",
      "TF" => "French Southern Territories",
      "TL" => "Timor-Leste",
      "TN" => "Tunisia",
      "TR" => "Turkey",
      "UA" => "Ukraine",
      "VA" => "Vatican City",
      "VG" => "British Virgin Islands",
      "WF" => "Wallis and Futuna",
      "XK" => "Kosovo",
      "YE" => "Yemen",
      "YT" => "Mayotte"
    }

    Map.get(names, code, code)
  end

  defp get_bban_spec(_code) do
    # Simplified - in reality this would need to be derived from country modules
    "varies"
  end

  defp generate_metadata(valid_ibans, country_specs) do
    sepa_count = Enum.count(country_specs, fn {_code, spec} -> spec["sepa"] end)

    %{
      "total_countries" => map_size(valid_ibans),
      "sepa_countries" => sepa_count,
      "source" => "SWIFT IBAN Registry",
      "generated_at" => DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end

defp get_positions(nil, _iban), do: %{"start" => 0, "end" => 0}
  defp get_positions("", _iban), do: %{"start" => 0, "end" => 0}

  defp get_positions(value, iban) do
# Remove country code and check digits (first 4 chars)
    bban = String.slice(iban, 4..-1//1)

    case :binary.match(bban, value) do
      {start, length} ->
        # Add 4 to account for country code and check digits
        %{"start" => start + 4, "end" => start + 4 + length}

      :nomatch ->
        %{"start" => 0, "end" => 0}
    end
  end
end
