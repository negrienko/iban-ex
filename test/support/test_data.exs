defmodule IbanEx.TestData do
  @moduledoc """
  Centralized test data management for IbanEx test suite.
  Provides access to IBAN registry fixtures and test case generators.
  """

  @fixtures_path Path.join([__DIR__, "iban_test_fixtures.json"])

  @doc """
  Helper function to check if an IBAN is valid.
  Wraps IbanEx.Validator.validate/1 to provide a boolean result.
  """
  def valid?(iban) do
    case IbanEx.Validator.validate(iban) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  @doc """
  Load and decode the IBAN registry test fixtures.
  Returns the complete fixtures map with valid IBANs and country specs.
  """
  def load_fixtures do
    @fixtures_path
    |> File.read!()
    |> JSON.decode!()
  end

  @doc """
  Get valid IBANs for testing.

  ## Options
  - `:country` - Filter by country code (e.g., "DE", "FR")
  - `:sepa_only` - Only return SEPA country IBANs (default: false)
  - `:format` - `:electronic` or `:print` (default: :electronic)

  ## Examples

      iex> IbanEx.TestData.valid_ibans(country: "DE")
      ["DE89370400440532013000"]

      iex> IbanEx.TestData.valid_ibans(sepa_only: true) |> length()
      53
  """
  def valid_ibans(opts \\ []) do
    fixtures = load_fixtures()
    country = Keyword.get(opts, :country)
    sepa_only = Keyword.get(opts, :sepa_only, false)
    format = Keyword.get(opts, :format, :electronic)

    valid_ibans = fixtures["valid_ibans"]
    country_specs = fixtures["country_specs"]

    valid_ibans
    |> filter_by_country(country)
    |> filter_by_sepa(country_specs, sepa_only)
    |> extract_format(format)
  end

  @doc """
  Get country specifications from the registry.

  ## Options
  - `:country` - Get spec for specific country code

  ## Examples

      iex> IbanEx.TestData.country_spec("DE")
      %{"country_name" => "Germany", "iban_length" => 22, ...}
  """
  def country_spec(country_code) do
    load_fixtures()
    |> Map.get("country_specs")
    |> Map.get(country_code)
  end

  @doc """
  Get all country codes from the registry.
  """
  def all_country_codes do
    load_fixtures()
    |> Map.get("valid_ibans")
    |> Map.keys()
    |> Enum.sort()
  end

  @doc """
  Get SEPA country codes from the registry.
  """
  def sepa_country_codes do
    fixtures = load_fixtures()

    fixtures["country_specs"]
    |> Enum.filter(fn {_code, spec} -> spec["sepa"] end)
    |> Enum.map(fn {code, _spec} -> code end)
    |> Enum.sort()
  end

  @doc """
  Get edge case IBANs for testing boundary conditions.

  Returns a map with:
  - `:shortest` - Shortest valid IBAN (Norway, 15 chars)
  - `:longest` - Longest valid IBAN (Russia, 33 chars)
  - `:complex` - Complex IBANs with branch codes and national checks
  """
  def edge_cases do
    fixtures = load_fixtures()

    %{
      shortest: fixtures["valid_ibans"]["NO"]["electronic"],
      longest: fixtures["valid_ibans"]["RU"]["electronic"],
      complex: [
        fixtures["valid_ibans"]["FR"]["electronic"],
        fixtures["valid_ibans"]["IT"]["electronic"],
        fixtures["valid_ibans"]["ES"]["electronic"]
      ]
    }
  end

  @doc """
  Generate a random valid IBAN from the registry.
  """
  def random_valid_iban do
    fixtures = load_fixtures()
    country_code = fixtures["valid_ibans"] |> Map.keys() |> Enum.random()
    fixtures["valid_ibans"][country_code]["electronic"]
  end

  @doc """
  Get all IBANs with specific characteristics.

  ## Options
  - `:length` - Filter by exact IBAN length
  - `:has_branch_code` - Filter by presence of branch code
  - `:has_national_check` - Filter by presence of national check digit
  - `:numeric_only` - Filter by numeric-only BBAN structure

  ## Examples

      iex> IbanEx.TestData.ibans_with(length: 22)
      ["DE89370400440532013000", ...]
  """
  def ibans_with(opts) do
    fixtures = load_fixtures()
    specs = fixtures["country_specs"]
    valid_ibans = fixtures["valid_ibans"]

    specs
    |> filter_specs_by_options(opts)
    |> Enum.map(fn {code, _spec} -> valid_ibans[code]["electronic"] end)
  end

  # Private functions

  defp filter_by_country(valid_ibans, nil), do: valid_ibans

  defp filter_by_country(valid_ibans, country) do
    Map.take(valid_ibans, [country])
  end

  defp filter_by_sepa(valid_ibans, _country_specs, false), do: valid_ibans

  defp filter_by_sepa(valid_ibans, country_specs, true) do
    sepa_codes =
      country_specs
      |> Enum.filter(fn {_code, spec} -> spec["sepa"] end)
      |> Enum.map(fn {code, _spec} -> code end)

    Map.take(valid_ibans, sepa_codes)
  end

  defp extract_format(valid_ibans, format) do
    format_key = Atom.to_string(format)

    valid_ibans
    |> Enum.map(fn {_code, data} -> data[format_key] end)
  end

  defp filter_specs_by_options(specs, opts) do
    specs
    |> filter_by_length(Keyword.get(opts, :length))
    |> filter_by_branch_code(Keyword.get(opts, :has_branch_code))
    |> filter_by_national_check(Keyword.get(opts, :has_national_check))
    |> filter_by_numeric_only(Keyword.get(opts, :numeric_only))
  end

  defp filter_by_length(specs, nil), do: specs

  defp filter_by_length(specs, length) do
    Enum.filter(specs, fn {_code, spec} -> spec["iban_length"] == length end)
  end

  defp filter_by_branch_code(specs, nil), do: specs

  defp filter_by_branch_code(specs, has_branch) do
    Enum.filter(specs, fn {_code, spec} ->
      has_branch_code?(spec) == has_branch
    end)
  end

  defp filter_by_national_check(specs, nil), do: specs

  defp filter_by_national_check(specs, has_check) do
    Enum.filter(specs, fn {_code, spec} ->
      has_national_check?(spec) == has_check
    end)
  end

  defp filter_by_numeric_only(specs, nil), do: specs

  defp filter_by_numeric_only(specs, numeric_only) do
    Enum.filter(specs, fn {_code, spec} ->
      # Use numeric_only field if available, otherwise fall back to bban_spec check
      case spec["numeric_only"] do
        nil -> is_numeric_only?(spec["bban_spec"]) == numeric_only
        value -> value == numeric_only
      end
    end)
  end

  defp has_branch_code?(spec) do
    positions = spec["positions"]["branch_code"]
    positions["start"] != positions["end"]
  end

  defp has_national_check?(spec) do
    positions = spec["positions"]["national_check"]
    positions != nil and positions["start"] != positions["end"]
  end

  defp is_numeric_only?(bban_spec) do
    !String.contains?(bban_spec, ["!a", "!c"])
  end
end
