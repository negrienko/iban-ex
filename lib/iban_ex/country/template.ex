defmodule IbanEx.Country.Template do
  @moduledoc false

  alias IbanEx.Iban
  @type size() :: non_neg_integer()
  @type rule() :: Regex.t()
  @type country_code() :: <<_::16>> | atom()
  @type joiner() :: String.t()

  @callback size() :: size()
  @callback rule() :: rule()
  @callback incomplete_rule() :: rule()
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

      @doc """
      Return Regex without trailing “$” for parsing incomplete BBAN (part of IBAN string) (for partial suggestions)
      """
      @impl IbanEx.Country.Template
      @spec incomplete_rule() :: Regex.t()
      def incomplete_rule() do
        source =
          @rule
          |> Regex.source()
          |> String.slice(0..-2//1)
          |> String.replace("{", "{0,")

        opts =
          @rule
          |> Regex.opts()

        Regex.compile!(source, opts)
      end

      defoverridable to_string: 1, to_string: 2, size: 0, rule: 0, incomplete_rule: 0
    end
  end
end
