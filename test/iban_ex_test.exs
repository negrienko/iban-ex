defmodule IbanExTest do
  alias IbanEx.{Country, Iban, Parser}
  use ExUnit.Case, async: true
  doctest_file "README.md"
  doctest IbanEx.Country.AT
  doctest IbanEx.Country.BE
  doctest IbanEx.Country.BG
  doctest IbanEx.Country.CH
  doctest IbanEx.Country.CY
  doctest IbanEx.Country.CZ
  doctest IbanEx.Country.DE
  doctest IbanEx.Country.DK
  doctest IbanEx.Country.EE
  doctest IbanEx.Country.ES
  doctest IbanEx.Country.FI
  doctest IbanEx.Country.FR
  doctest IbanEx.Country.GB
  doctest IbanEx.Country.GI
  doctest IbanEx.Country.GR
  doctest IbanEx.Country.HR
  doctest IbanEx.Country.HU
  doctest IbanEx.Country.IE
  doctest IbanEx.Country.IT
  doctest IbanEx.Country.LI
  doctest IbanEx.Country.LT
  doctest IbanEx.Country.LU
  doctest IbanEx.Country.LV
  doctest IbanEx.Country.MC
  doctest IbanEx.Country.MT
  doctest IbanEx.Country.NL
  doctest IbanEx.Country.NO
  doctest IbanEx.Country.PL
  doctest IbanEx.Country.PT
  doctest IbanEx.Country.RO
  doctest IbanEx.Country.SE
  doctest IbanEx.Country.SM
  doctest IbanEx.Country.SI
  doctest IbanEx.Country.SK
  doctest IbanEx.Country.UA
  doctest IbanEx.Country.VA

  @ibans [
    "AL47212110090000000235698741",
    "AD1200012030200359100100",
    "AT611904300234573201",
    "AZ21NABZ00000000137010001944",
    "BH67BMAG00001299123456",
    "BE68539007547034",
    "BA391290079401028494",
    "BR1800360305000010009795493C1",
    "BG80BNBG96611020345678",
    "CR05015202001026284066",
    "HR1210010051863000160",
    "CY17002001280000001200527600",
    "CZ6508000000192000145399",
    "DK5000400440116243",
    "DO28BAGR00000001212453611324",
    "EG380019000500000000263180002",
    "SV62CENR00000000000000700025",
    "EE382200221020145685",
    "FO6264600001631634",
    "FI2112345600000785",
    "FR1420041010050500013M02606",
    "GE29NB0000000101904917",
    "DE89370400440532013000",
    "GI75NWBK000000007099453",
    "GR1601101250000000012300695",
    "GL8964710001000206",
    "GT82TRAJ01020000001210029690",
    "HU42117730161111101800000000",
    "IS140159260076545510730339",
    "IE29AIBK93115212345678",
    "IL620108000000099999999",
    "IT60X0542811101000000123456",
    "JO94CBJO0010000000000131000302",
    "KZ86125KZT5004100100",
    "XK051212012345678906",
    "KW81CBKU0000000000001234560101",
    "LV80BANK0000435195001",
    "LB62099900000001001901229114",
    "LI21088100002324013AA",
    "LT121000011101001000",
    "LU280019400644750000",
    "MK07250120000058984",
    "MT84MALT011000012345MTLCAST001S",
    "MR1300020001010000123456753",
    "MC5811222000010123456789030",
    "ME25505000012345678951",
    "NL91ABNA0417164300",
    "NO9386011117947",
    "PK36SCBL0000001123456702",
    "PL61109010140000071219812874",
    "PT50000201231234567890154",
    "QA58DOHB00001234567890ABCDEFG",
    "MD24AG000225100013104168",
    "RO49AAAA1B31007593840000",
    "SM86U0322509800000000270100",
    "SA0380000000608010167519",
    "RS35260005601001611379",
    "SK3112000000198742637541",
    "SI56263300012039086",
    "ES9121000418450200051332",
    "SE4550000000058398257466",
    "CH9300762011623852957",
    "TL380080012345678910157",
    "TR330006100519786457841326",
    "UA213223130000026007233566001",
    "AE070331234567890123456",
    "GB29NWBK60161331926819",
    "VA59001123000012345678",
    "VG96VPVG0000012345678901"
  ]

  test "parsing valid IBANs from available countries returns {:ok, %IbanEx.Iban{}}" do
    assert Enum.all?(@ibans, fn iban ->
             iban_country = iban |> String.upcase() |> String.slice(0..1)

             case {Country.is_country_code_supported?(iban_country), Parser.parse(iban)} do
               {true, {:ok, %Iban{}}} ->
                 true

               {false, {:error, :unsupported_country_code}} ->
                 true

               _ ->
                 false
             end
           end)
  end
end
