defprotocol IbanEx.Deserialize do
  @type iban() :: IbanEx.Iban.t()
  @type iban_or_error() ::
          iban()
          | {:invalid_checksum, binary()}
          | {:invalid_format, binary()}
          | {:invalid_length, binary()}
          | {:can_not_parse_map, binary()}
          | {:unsupported_country_code, binary()}

  @spec to_iban(t()) :: iban_or_error()
  def to_iban(value)
end

defimpl IbanEx.Deserialize, for: [BitString, String] do
  alias IbanEx.{Parser, Error}
  @type iban() :: IbanEx.Iban.t()
  @type iban_or_error() ::
          iban()
          | {:invalid_checksum, binary()}
          | {:invalid_format, binary()}
          | {:invalid_length, binary()}
          | {:can_not_parse_map, binary()}
          | {:unsupported_country_code, binary()}
  def to_iban(string) do
    case Parser.parse(string) do
      {:ok, iban} -> iban
      {:error, error_code} -> {error_code, Error.message(error_code)}
    end
  end
end

defimpl IbanEx.Deserialize, for: Map do
  alias IbanEx.{Iban, Error}

  @type iban() :: IbanEx.Iban.t()
  @type iban_or_error() ::
          iban()
          | {:invalid_checksum, binary()}
          | {:invalid_format, binary()}
          | {:invalid_length, binary()}
          | {:can_not_parse_map, binary()}
          | {:unsupported_country_code, binary()}

  def to_iban(
        %{
          country_code: _country_code,
          check_digits: _check_sum_digits,
          bank_code: _bank_code,
          branch_code: _branch_code,
          national_check: _national_check,
          account_number: _account_number
        } = map
      ) do
    struct(Iban, map)
  end

  def to_iban(
        %{
          "country_code" => _country_code,
          "check_digits" => _check_sum_digits,
          "bank_code" => _bank_code,
          "branch_code" => _branch_code,
          "national_check" => _national_check,
          "account_number" => _account_number
        } = map
      ) do
    atomized_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
    to_iban(atomized_map)
  end

  def to_iban(map) when is_map(map), do: {:can_not_parse_map, Error.message(:can_not_parse_map)}
end

defimpl IbanEx.Deserialize, for: List do
  alias IbanEx.Iban
  def to_iban(list), do: struct(Iban, Map.new(list))
end
