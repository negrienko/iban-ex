defmodule IbanEx.MixProject do
  use Mix.Project

  @source_url "https://g.tulz.dev/opensource/iban-ex"
  @version "0.1.1"

  def project do
    [
      app: :iban_ex,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    """
    Library for working with IBAN numbers (parsing, validating and checking and formatting)
    """
  end

  defp dialyzer() do
    [
      plt_add_apps: [:iban_ex]
    ]
  end

  defp package() do
    [
      maintainers: ["Danylo Negrienko"],
      licenses: ["Apache-2.0"],
      links: %{"Git Repository" => @source_url, "Author's Blog" => "https://negrienko.com"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "IbanEx",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/iban_ex",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Checks
      {:lettuce, "~> 0.3.0", only: :dev},
      {:ex_check, "~> 0.14.0", only: ~w(dev test)a, runtime: false},
      {:credo, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:dialyxir, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:doctor, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:ex_doc, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:sobelow, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:mix_audit, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:observer_cli, "~> 1.7.4", only: :dev, runtime: false},
      {:elixir_sense, github: "elixir-lsp/elixir_sense", only: ~w(dev)a}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
