
# Tooling to auto-generate ReleasePlugs

The goal of tooling here is **not** runtime cleverness.
It is **compile-time scaffolding** that:

* generates boring, explicit code
* enforces conventions
* reduces copy-paste errors
* produces code you can freely edit afterward

---

## 1.1 Generator philosophy

* Output **plain Elixir modules**
* No macros at runtime
* No hidden indirection
* Safe to delete later

Think: `mix phx.gen.release`, not “dynamic routing engine”.

---

## 1.2 Generator input (simple, explicit)

Example config (could live in `rel/releases/route5.exs`):

```elixir
%{
  name: "Route5Release",
  type: :env_then_runtime,

  env_gate: %{
    test: ["alpha", "beta"],
    prod: ["stable"]
  },

  runtime: %{
    fetcher: :fabl,
    module: "release-check",
    decision: """
    if data["isProd"], do: :webcore, else: :legacy
    """
  },

  fallback: :legacy
}
```

This is **not** used at runtime.
It is **only** input to code generation.

---

## 1.3 Generator output (what gets created)

```elixir
defmodule SpotiWeb.Releases.Route5Release do
  @behaviour SpotiWeb.ReleasePlug

  alias SpotiWeb.EnvGate
  alias SpotiWeb.ReleaseGates
  alias SpotiWeb.Runtime.SafeFetch
  alias SpotiWeb.PreflightFetchers.FABL
  alias SpotiWeb.Release
  alias SpotiWeb.ForwardByStrategy

  @fallback :legacy

  @gates %{
    test: EnvGate.new(allow: ["alpha", "beta"]),
    prod: EnvGate.new(allow: ["stable"])
  }

  @strategy Release.env_then_runtime(
              :webcore,
              fn data ->
                if data["isProd"], do: :webcore, else: :legacy
              end
            )

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    env = conn.assigns[:env]

    if not ReleaseGates.allowed?(@gates, env, name) do
      ForwardByStrategy.forward(conn, @fallback)
    else
      runtime_data =
        case SafeFetch.fetch(FABL, module: "release-check", conn: conn) do
          {:ok, data} -> data
          :error -> nil
        end

      target =
        try do
          @strategy.(env, runtime_data)
        rescue
          _ -> @fallback
        end

      ForwardByStrategy.forward(conn, target)
    end
  end
end
```

📌 This file is now:

* owned by humans
* debuggable
* testable
* disposable

---

## 1.4 Why this tooling is worth it

* You **standardise structure**, not behaviour
* Reviews focus on *policy*, not plumbing
* New routes don’t invent new patterns
* Refactors are mechanical

This is the *right* kind of automation.

---

