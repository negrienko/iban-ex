# IbanEx

Elixir library for working with IBAN numbers (parsing, validating, checking and formatting)

## What is an IBAN?

IBAN (which stands for International Bank Account Number) is an internationally agreed code made up of up to 34 letters and numbers which helps banks make sure that international transfers are processed correctly.

In just a few letters and numbers, the IBAN captures all of the country, bank, and account details you need to send or receive money internationally. This system is used throughout Europe, and also recognised in some areas of the Middle East, North Africa and the Caribbean. Find IBAN examples for every country where it's used.

## HowTo Use

### Successfull case to parse IBAN

#### Parse string with valid formatted IBAN from supported country

```elixir
{:ok, iban} = "FI2112345600000785" |> IbanEx.Parser.parse()
IO.inspect(iban)
IbanEx.Iban.pretty(iban)
```

#### Success case responses

```elixir
%IbanEx.Iban{
  country_code: "FI",
  check_digits: "21",
  bank_code: "123456",
  branch_code: nil,
  national_check: "5",
  account_number: "0000078"
}

"FI 21 123456 0000078 5"
```

### Errors cases of IBAN parsing

#### Parse strings with invalid formatted IBANs from unsupported and supported countries

```elixir
{:error, unsupported_country_code} = "AZ21NABZ00000000137010001944" |> IbanEx.Parser.parse()
IO.inspect(IbanEx.Error.message(unsupported_country_code), label: unsupported_country_code)

{:error, invalid_length_code} = "AT6119043002345732012" |> IbanEx.Parser.parse()
IO.inspect(IbanEx.Error.message(invalid_length_code), label: invalid_length_code)

{:error, invalid_checksum} = "AT621904300234573201" |> IbanEx.Parser.parse()
IO.inspect(IbanEx.Error.message(invalid_checksum), label: invalid_checksum)
```

#### Error cases response

```elixir
unsupported_country_code: "Unsupported country code"
invalid_length: "IBAN violates the required length"
invalid_checksum: "IBAN's checksum is invalid"
```

## Installation

The package can be installed by adding `iban_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iban_ex, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/iban_ex>.
