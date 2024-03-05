defmodule IbanEx.Country.Template do
  alias IbanEx.Iban
  @type size() :: non_neg_integer()
  @type rule() :: Regex.t()
  @type country_code() :: <<_::16>> | atom()
  @type joiner() :: String.t()

  @callback size() :: size()
  @callback rule() :: rule()
  @callback to_s(Iban.t(), joiner()) :: String.t()
  @callback to_s(Iban.t()) :: String.t()
end
