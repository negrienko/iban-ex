defmodule IbanEx.Iban do
  @moduledoc false

  alias IbanEx.Formatter
  alias IbanEx.{Serialize}

  @type t :: %__MODULE__{
    country_code: <<_::16>>,
    check_digits: String.t(),
    bank_code: String.t(),
    branch_code: String.t() | nil,
    national_check: String.t() | nil,
    account_number: String.t()
  }
  defstruct country_code: "UA", check_digits: nil, bank_code: nil, branch_code: nil, national_check: nil, account_number: nil

  @spec to_map(IbanEx.Iban.t()) :: map()
  defdelegate to_map(iban), to: Serialize

  @spec to_string(IbanEx.Iban.t()) :: binary()
  defdelegate to_string(iban), to: Serialize

  @spec pretty(IbanEx.Iban.t()) :: binary()
  defdelegate pretty(iban), to: Formatter

  @spec splitted(IbanEx.Iban.t()) :: binary()
  defdelegate splitted(iban), to: Formatter

  @spec compact(IbanEx.Iban.t()) :: binary()
  defdelegate compact(iban), to: Formatter
end
