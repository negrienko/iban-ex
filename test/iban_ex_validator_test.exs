defmodule IbanExValidatorTest do
  alias IbanEx.{Validator}
  use ExUnit.Case, async: true

  test "check IBANs length" do
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
