defmodule IbanEx.Country.Template do
  @moduledoc false

  alias IbanEx.Iban
  @type size() :: non_neg_integer()
  @type rule() :: Regex.t()
  @type country_code() :: <<_::16>> | atom()
  @type joiner() :: String.t()

  @callback size() :: size()
  @callback rule() :: rule()
  @callback rules() :: []
  @callback rules_map() :: %{}
  @callback bban_fields() :: [atom()]
  @callback bban_size() :: non_neg_integer()
  @callback to_string(Iban.t(), joiner()) :: String.t()
  @callback to_string(Iban.t()) :: String.t()

  defmacro __using__(_opts) do
    quote do
      alias IbanEx.Iban
      @behaviour IbanEx.Country.Template

      @impl IbanEx.Country.Template
      @spec to_string(Iban.t()) :: binary()
      @spec to_string(Iban.t(), binary()) :: binary()
      def to_string(
            %Iban{
              country_code: country_code,
              check_digits: check_digits,
              bank_code: bank_code,
              branch_code: _branch_code,
              national_check: _national_check,
              account_number: account_number
            } = _iban,
            joiner \\ " "
          ) do
        [country_code, check_digits, bank_code, account_number]
        |> Enum.join(joiner)
      end

      @impl IbanEx.Country.Template
      @spec size() :: integer()
      def size(), do: @size

      @doc """
      Return Regex for parsing complete BBAN (part of IBAN string)
      """
      @impl IbanEx.Country.Template
      @spec rule() :: Regex.t()
      def rule(), do: @rule

      @impl IbanEx.Country.Template
      @spec bban_size() :: integer()
      def bban_size() do
        {_rules, bban_size} = calculate_rules()
        bban_size
      end

      @impl IbanEx.Country.Template
      @spec bban_fields() :: []
      def bban_fields(), do: rules_map() |> Map.keys()

      @impl IbanEx.Country.Template
      @spec rules_map() :: %{}
      def rules_map(), do: rules() |> Map.new()

      @impl IbanEx.Country.Template
      @spec rules() :: []
      def rules() do
        {rules, _bban_size} = calculate_rules()
        rules
      end

      defp calculate_rules() do
        scanner = ~r/\(\?\<([\w_]+)\>(([^{]+)\{(\d+)\})\)/i

        source =
          @rule
          |> Regex.source()

        {list, bban_length} =
          Regex.scan(scanner, source)
          |> Enum.reduce({[], 0}, fn [_part, k, r, _syms, l], {list, position} = acc ->
            key = String.to_atom(k)
            {:ok, regex} = Regex.compile(r, "i")
            length = String.to_integer(l)
            left = position
            right = left + length - 1
            {[{key, %{regex: regex, range: left..right}} | list], right + 1}
          end)

        {Enum.reverse(list), bban_length}
      end

      defoverridable to_string: 1, to_string: 2, size: 0, rule: 0, rules: 0
    end
  end
end
