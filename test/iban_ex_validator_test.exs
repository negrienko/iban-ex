defmodule IbanExValidatorTest do
  alias IbanEx.{Validator}
  use ExUnit.Case, async: true

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

  test "Check Account number format positive cases" do
    Enum.all?(@ibans, &assert(!Validator.iban_violates_account_number_format?(&1), &1))
  end

  test "Check National check format positive cases" do
    Enum.all?(@ibans, &assert(!Validator.iban_violates_national_check_format?(&1), &1))
  end

  test "Check Branch code format positive cases" do
    Enum.all?(@ibans, &assert(!Validator.iban_violates_branch_code_format?(&1), &1))
  end

  test "Check Bank code format positive cases" do
    Enum.all?(@ibans, &assert(!Validator.iban_violates_bank_code_format?(&1), &1))
  end

  test "Check Account number format negative cases" do
    cases = [
      # shorter then need
      {"AL4721211009000000023568741", true},
      {"AD120001203020035900100", true},
      {"AZ21NABZ0000000013701000944", true},
      # invalid characters (leters) in number
      {"AT6119043002A4573201", true},
      {"BH67BMAG000012991A3456", true},
      {"BE685390075X7034", true},
      {"BA391290079401S28494", true},
      {"BR180036030500001000979549CC1", true},
      {"HR12100100518630001", true},
      # shorter then need and has
      # invalid characters (leters) in number
      {"BR18003603050000100097CC1", true},
      {"CR050152020010262806Ї", true},
      # FIXME it is invalid IBAN for Bulgaria — need to change a rules function in Country Template module
      # {"BG80BNBG9661102034567Ї", true},
    ]

    Enum.all?(cases, fn {iban, result} ->
      assert(Validator.iban_violates_account_number_format?(iban) == result, iban)
    end)
  end

  test "Check IBANs length" do
    cases = [
      {"FG2112345CC6000007", {:error, :unsupported_country_code}},
      {"UK2112345CC6000007", {:error, :unsupported_country_code}},
      {"FI2112345CC6000007", :ok},
      {"FI2112345CC6000007a", {:error, :length_to_long}},
      {"FI2112345CC600007", {:error, :length_to_short}}
    ]

    Enum.all?(cases, fn {iban, result} ->
      assert Validator.check_iban_length(iban) == result
    end)
  end
end
