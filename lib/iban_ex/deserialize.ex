defprotocol IbanEx.Deserialize do
  @type iban_or_error() :: IbanEx.Iban.t() | {:error, :can_not_parse_map | atom()}
  @spec to_iban(t()) :: iban_or_error()
  def to_iban(value)
end

defimpl IbanEx.Deserialize, for: [BitString, String] do
  alias IbanEx.{Parser, Error}
  @type iban_or_error() :: IbanEx.Iban.t() | {:error, atom()}
  @spec to_iban(String.t()) :: iban_or_error()
  @spec to_iban(binary()) :: IbanEx.Iban.t()
  def to_iban(string) do
    case Parser.parse(string) do
      {:ok, iban} -> iban
      {:error, error_code} -> {error_code, Error.message(error_code)}
    end
  end
end

defimpl IbanEx.Deserialize, for: Map do
  alias IbanEx.Iban
  @type iban_or_error() :: IbanEx.Iban.t() | {:error, :can_not_parse_map}

  @spec to_iban(map()) :: iban_or_error()
  def to_iban(
        %{
          country_code: _country_code,
          check_digits: _check_sum_digits,
          bank_code: _bank_code,
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
          "account_number" => _account_number
        } = map
      ) do
    atomized_map = for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
    to_iban(atomized_map)
  end

  def to_iban(map) when is_map(map), do: {:error, :can_not_parse_map}
end
