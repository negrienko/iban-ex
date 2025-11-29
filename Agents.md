This is a web application written using the Phoenix web framework.

## Project guidelines

- Use `mix check` alias when you are done with all changes and fix any pending issues
- Use the already included and available `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`. Req is included by default and is the preferred HTTP client for Banker
- Use the already included and available Elixir native JSON module to encode and decode JSON, **avoid** `:jason`, `:poison`, and other. JSON is a part of Elixir standard library and is the preferred JSON parser and generator for Banker

<!-- elixir-toolkit-commands--execution-start -->

## Command Execution

**🔴 CRITICAL: ALWAYS prefix mix, iex commands with environment variables:**

**For Development:**
```bash
env $(cat .dev.env | xargs) mix <COMMAND>
env $(cat .dev.env | xargs) iex -S mix
```

**For Testing:**
```bash
env $(cat .test.env | xargs) mix test
env $(cat .test.env | xargs) iex -S mix
```

**Examples:**
```bash
# Development
env $(cat .dev.env | xargs) mix test
env $(cat .dev.env | xargs) mix compile
env $(cat .dev.env | xargs) mix phx.server

# Testing
env $(cat .test.env | xargs) mix test
env $(cat .test.env | xargs) mix test test/banker/assistants/invoice_data_assistant_test.exs
env $(cat .test.env | xargs) iex -S mix
```

**NEVER run mix commands without the appropriate ENV file prefix** - will fail with missing ENV variable errors.
- Use `.dev.env` for development commands
- Use `.test.env` for test commands


<!-- elixir-toolkit-commands--execution-end -->

<!-- tool-usage-start -->
## Tool Usage Guidelines

<!-- tool-usage:code-start -->
### Code base analysys and semantic code search

Register project to make Tree Sitter tool available for analyzing the Banker codebase and get next posibilities: 

- **Search codebase**: Find files, functions, or patterns
- **Understand architecture**: Explore modules, domains, resources
- **Code navigation**: Jump to definitions, find usages
- **Quality analysis**: Detect complexity, duplication, dependencies
- **Strategic exploration**: Understand domain structure and relationships

**Always use tree_sitter_banker tool** for: 

  1. **Code Navigation**: Extract functions, classes, modules. Find where symbols are used. Search with regex patterns. Read file contents efficiently. Get abstract syntax trees
  2. **Analysis Tools**: Measure cyclomatic complexity. Find imports and dependencies. Detect code duplication. Execute tree-sitter queries
  3. **Project Understanding**: Get file lists by pattern or extension. Analyze project structure. Get file metadata and line counts. Navigate dependencies.

<!-- tool-usage:code-end -->

<!-- tool-usage:documentation-start -->
### Documentation
- **Always use HEXDocs tool** to get and analyze **actual documentation** for Elixir, Elixir libraries and Phoenix framework
<!-- tool-usage:documentation-end -->

<!-- tool-usage:database-start -->
### Database Access
- **Use only** postgres_banker_dev tool to comunicate with development database
- **Use only** postgres_banker_test tool to comunicate with test database
- **Only in case when** postgres_banker_dev or postgres_banker_test tools is unavaliable you can get data from databases directly:
  - Development database: `psql banker_dev -c "<query>"`
  - Test database: `psql banker_test -c "<query>"`
- **NEVER** try do anything with production database. You are **FORBIDDEN** from execute any queries on prod environmemnt
<!-- tool-usage:database-end -->

<!-- tool-usage-end -->

<!-- guidelines-start -->

<!-- guidelines:elixir-start -->
## Elixir Core Usage Rules

### Pattern Matching
- Use pattern matching over conditional logic when possible
- Prefer to match on function heads instead of using `if`/`else` or `case` in function bodies
- `%{}` matches ANY map, not just empty maps. Use `map_size(map) == 0` guard to check for truly empty maps

### Error Handling
- Use `{:ok, result}` and `{:error, reason}` tuples for operations that can fail
- Avoid raising exceptions for control flow
- Use `with` for chaining operations that return `{:ok, _}` or `{:error, _}`

### Common Mistakes to Avoid
- Elixir has no `return` statement, nor early returns. The last expression in a block is always returned.
- Don't use `Enum` functions on large collections when `Stream` is more appropriate
- Avoid nested `case` statements - refactor to a single `case`, `with` or separate functions
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Lists and enumerables cannot be indexed with brackets. Use pattern matching or `Enum` functions
- Prefer `Enum` functions like `Enum.reduce` over recursion
- When recursion is necessary, prefer to use pattern matching in function heads for base case detection
- Using the process dictionary is typically a sign of unidiomatic code
- Only use macros if explicitly requested
- There are many useful standard library functions, prefer to use them where possible
- **Never** nest multiple modules in the same file as it can cause cyclic dependencies and compilation errors

### Function Design
- Use guard clauses: `when is_binary(name) and byte_size(name) > 0`
- Prefer multiple function clauses over complex conditional logic
- Name functions descriptively: `calculate_total_price/2` not `calc/2`
- Predicate function names should not start with `is` and should end in a question mark.
- Names like `is_thing` should be reserved for guards

### Data Structures
- Use structs over maps when the shape is known: `defstruct [:name, :age]`
- Use maps for dynamic key-value data
- **Never** use map access syntax (`changeset[:field]`) on structs as they do not implement the Access behaviour by default. For regular structs, you **must** access the fields directly, such as `my_struct.field` or use higher level APIs that are available on the struct if they exist, `Ecto.Changeset.get_field/2` for changesets
- Elixir's standard library has everything necessary for date and time manipulation. Familiarize yourself with the common `Time`, `Date`, `DateTime`, and `Calendar` interfaces by accessing their documentation as necessary. **Never** install additional dependencies unless asked or for date/time parsing (which you can use the `date_time_parser` package)
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Predicate function names should not start with `is_` and should end in a question mark. Names like `is_thing` should be reserved for guards
- Elixir's builtin OTP primitives like `DynamicSupervisor` and `Registry`, require names in the child spec, such as `{DynamicSupervisor, name: Banker.MyDynamicSup}`, then you can use `DynamicSupervisor.start_child(Banker.MyDynamicSup, child_spec)`
- Use `Task.async_stream(collection, callback, options)` for concurrent enumeration with back-pressure. The majority of times you will want to pass `timeout: :infinity` as option
- Elixir variables are immutable, but can be rebound, so for block expressions like `if`, `case`, `cond`, etc
  you *must* bind the result of the expression to a variable if you want to use it and you CANNOT rebind the result inside the expression, ie:

      # INVALID: we are rebinding inside the `if` and the result never gets assigned
      if connected?(socket) do
        socket = assign(socket, :val, val)
      end

      # VALID: we rebind the result of the `if` to a new variable
      socket =
        if connected?(socket) do
          assign(socket, :val, val)
        end
- Prefer keyword lists for options: `[timeout: 5000, retries: 3]`
- Prefer to prepend to lists `[new | list]` not `list ++ [new]`
- Elixir lists **do not support index based access via the access syntax**

  **Never do this (invalid)**:

      i = 0
      mylist = ["blue", "green"]
      mylist[i]

  Instead, **always** use `Enum.at`, pattern matching, or `List` for index based list access, ie:

      i = 0
      mylist = ["blue", "green"]
      Enum.at(mylist, i)


### Mix Tasks

- Use `mix help` to list available mix tasks
- Use `mix help task_name` to get docs for an individual task
- Read the docs and options before using tasks (by using `mix help task_name`)
- To debug test failures, run tests in a specific file with `mix test test/my_test.exs` or run all previously failed tests with `mix test --failed`
- `mix deps.clean --all` is **almost never needed**. **Avoid** using it unless you have good reason

### Testing
- Run tests in a specific file with `mix test test/my_test.exs` and a specific test with the line number `mix test path/to/test.exs:123`
- Limit the number of failed tests with `mix test --max-failures n`
- Use `@tag` to tag specific tests, and `mix test --only tag` to run only those tests
- Use `assert_raise` for testing expected exceptions: `assert_raise ArgumentError, fn -> invalid_function() end`
- Use `mix help test` to for full documentation on running tests

### Debugging

- Use `dbg/1` to print values while debugging. This will display the formatted value and other relevant information in the console.

<!-- guidelines:elixir-end -->

<!-- guidelines:otp-start -->
## OTP Usage Rules

### GenServer Best Practices
- Keep state simple and serializable
- Handle all expected messages explicitly
- Use `handle_continue/2` for post-init work
- Implement proper cleanup in `terminate/2` when necessary

### Process Communication
- Use `GenServer.call/3` for synchronous requests expecting replies
- Use `GenServer.cast/2` for fire-and-forget messages.
- When in doubt, use `call` over `cast`, to ensure back-pressure
- Set appropriate timeouts for `call/3` operations

### Fault Tolerance
- Set up processes such that they can handle crashing and being restarted by supervisors
- Use `:max_restarts` and `:max_seconds` to prevent restart loops

### Task and Async
- Use `Task.Supervisor` for better fault tolerance
- Handle task failures with `Task.yield/2` or `Task.shutdown/2`
- Set appropriate task timeouts
- Use `Task.async_stream/3` for concurrent enumeration with back-pressure

<!-- guidelines:otp-end -->

<!-- guidelines-end -->

<cicada>
  **ALWAYS use cicada-mcp tools for Elixir and Python code searches. NEVER use Grep/Find for these tasks.**

  ### Use cicada tools for:
  - YOUR PRIMARY TOOL - Start here for ALL code exploration and discovery. `mcp__cicada__query`
  - DEEP-DIVE TOOL: View a module's complete API and dependencies after discovering it with query. `mcp__cicada__search_module`
  - DEEP-DIVE TOOL: Find function definitions and call sites after discovering with query. `mcp__cicada__search_function`
  - UNIFIED HISTORY TOOL: One tool for all git history queries - replaces get_blame, get_commit_history, find_pr_for_line, and get_file_pr_history. `mcp__cicada__git_history`
  - ANALYSIS TOOL: Find potentially unused public functions with confidence levels. `mcp__cicada__find_dead_code`
  - DRILL-DOWN TOOL: Expand a query result to see complete details. `mcp__cicada__expand_result`
  - ADVANCED: Execute jq queries directly against the Cicada index for custom analysis and data exploration. `mcp__cicada__query_jq`

  ### DO NOT use Grep for:
  - ❌ Searching for module structure
  - ❌ Searching for function definitions
  - ❌ Searching for module imports/usage

  ### You can still use Grep for:
  - ✓ Non-code files (markdown, JSON, config)
  - ✓ String literal searches
  - ✓ Pattern matching in single line comments
</cicada>

