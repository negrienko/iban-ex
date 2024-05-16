# IbanEx

Elixir library for working with IBAN numbers (parsing, validating, checking and formatting)

## What is an IBAN?

IBAN (which stands for International Bank Account Number) is an internationally agreed code made up of up to 34 letters and numbers which helps banks make sure that international transfers are processed correctly.

In just a few letters and numbers, the IBAN captures all of the country, bank, and account details you need to send or receive money internationally. This system is used throughout Europe, and also recognised in some areas of the Middle East, North Africa and the Caribbean. Find IBAN examples for every country where it's used.

## HowTo Use

### Successfull case to parse IBAN

  ```elixir
      iex>  "FI2112345600000785" |> IbanEx.Parser.parse()
      {:ok, %IbanEx.Iban{
        country_code: "FI",
        check_digits: "21",
        bank_code: "123456",
        branch_code: nil,
        national_check: "5",
        account_number: "0000078"
      }}
  ```

### Errors cases of IBAN parsing

#### To check IBAN's country is supported

  ```elixir
      iex> {:error, unsupported_country_code} = IbanEx.Parser.parse("ZU21NABZ00000000137010001944")
      {:error, :unsupported_country_code}
      iex> IbanEx.Error.message(unsupported_country_code)
      "Unsupported country code"
  ```

#### Validate and check IBAN length

  ```elixir
      iex> {:error, invalid_length} = IbanEx.Parser.parse("AT6119043002345732012")
      {:error, :invalid_length}
      iex> IbanEx.Error.message(invalid_length)
      "IBAN violates the required length"
  ```

  ```elixir
      iex> {:error, length_to_long} = IbanEx.Validator.check_iban_length("AT6119043002345732012")
      {:error, :length_to_long}
      iex> IbanEx.Error.message(length_to_long)
      "IBAN longer then required length"
      iex> {:error, length_to_short} = IbanEx.Validator.check_iban_length("AT61190430023457320")
      {:error, :length_to_short}
      iex> IbanEx.Error.message(length_to_short)
      "IBAN shorter then required length"
  ```

#### Validate IBAN checksum

  ```elixir
      iex> {:error, invalid_checksum} = IbanEx.Parser.parse("AT621904300234573201")
      {:error, :invalid_checksum}
      iex> IbanEx.Error.message(invalid_checksum)
      "IBAN's checksum is invalid"
  ```

## Installation

The package can be installed by adding `iban_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iban_ex, "~> 0.1.7"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/iban_ex>.
