# Spoti Routing & Release Architecture

## 1. Purpose

This Phoenix application is the **single HTTP ingress** for Spoti.

Its responsibilities:

* Accept all user traffic
* Enforce environment isolation (TEST / PROD)
* Apply release strategies
* Forward traffic to downstream platforms (Webcore, Legacy, etc.)

It does **not**:

* Render content
* Contain business logic
* Perform data aggregation

---

## 2. Core principles

### 2.1 Routes must be boring

Routes describe *intent*, not mechanics.

Good:

```elixir
get "/sample/route/5", SpotiWeb.Releases.Route5Release
```

Better (after rollout):

```elixir
get "/sample/route/5", ForwardToWebcore
```

---

### 2.2 Release logic must be swappable

Every route supports this lifecycle:

1. Controlled rollout via ReleasePlug
2. Validation in TEST and PROD
3. Promotion via one-line diff
4. Deletion of release logic

---

### 2.3 Runtime decisions are opt-in

If a route depends on runtime signals (FABL):

* It must be explicit
* It must fail safe
* It must have a fallback

---

## 3. Key abstractions

### 3.1 Forwarders

Forwarders send traffic downstream.

Examples:

* `ForwardToWebcore`
* `ForwardToLegacy`

They are simple Plugs.

---

### 3.2 Release strategies

Strategies decide **which target** to use.

Examples:

* static
* by environment
* by runtime (FABL)
* hybrid (env → runtime)

Strategies never perform IO.

---

### 3.3 ReleasePlugs (core abstraction)

A **ReleasePlug**:

* is a Plug
* owns its guardrails
* always forwards or halts
* never crashes upstream

```elixir
@behaviour SpotiWeb.ReleasePlug
```

---

## 4. FABL runtime (preflight) fetching

### 4.1 Purpose

FABL modules provide **release signals**, e.g.:

```json
{
  "isProd": true,
  "canary": false
}
```

---

### 4.2 Endpoints

| Environment | Base URL                                                               |
| ----------- | ---------------------------------------------------------------------- |
| Local       | [https://localhost:3210](https://localhost:3210)                       |
| Test        | [https://fabl.test.api.spoti.co.ke](https://fabl.test.api.spoti.co.ke) |
| Prod        | [https://fabl.live.api.spoti.co.ke](https://fabl.live.api.spoti.co.ke) |

---

### 4.3 What FABL receives

Every FABL request includes:

* full request path
* path parameters
* query parameters

Example:

```
GET /module/release-check
  ?path=/sample/route/5
  &name=gor-mahia
```

This allows FABL to reason contextually.

---

## 5. Guardrails

### 5.1 Timeouts

Runtime fetches have strict timeouts (e.g. 150ms).

---

### 5.2 Fallbacks

Each ReleasePlug defines a fallback target:

```elixir
@fallback :legacy
```

Triggered on:

* timeout
* fetch failure
* invalid data
* strategy error

---

### 5.3 Circuit breakers

Circuit breakers prevent repeated calls to failing dependencies.

In this system:

* they protect FABL calls
* they fail open to fallback
* they preserve routing stability

---

## 6. Env gating (allow / deny)

Env gates provide **O(1)** route-level filtering.

```elixir
@gates %{
  test: EnvGate.new(allow: ["alpha", "beta"]),
  prod: EnvGate.new(allow: ["stable"])
}
```

Rules:

* If no gate exists → allow
* If denied → fallback immediately

---

## 7. Example routes

### Route 1 — static

```elixir
get "/sample/route/1", ForwardToWebcore
```

---

### Route 3 — env split

```elixir
get "/sample/route/3", SpotiWeb.Releases.Route3Release
```

---

### Route 5 — env then FABL

```elixir
get "/sample/route/5", SpotiWeb.Releases.Route5Release
```

Promotion:

```elixir
get "/sample/route/5", ForwardToWebcore
```

---

### Route 6 — env allow/deny

```elixir
get "/sample/route/6/:name", SpotiWeb.Releases.Route6Release
```

Behaviour:

* Allowed names → Webcore
* Everything else → Legacy

---

## 8. Tooling

ReleasePlugs can be auto-generated from declarative specs.

Tooling:

* scaffolds safe defaults
* enforces conventions
* produces editable Elixir code

Generated code is **not special** — it is just code.

---

## 9. Mental model (final)

> **Routes point to ReleasePlugs**
> **ReleasePlugs orchestrate**
> **Strategies decide**
> **Forwarders execute**
> **Failures degrade safely**

If routing ever feels exciting — something is wrong.

---

## 10. Status

This architecture is:

* complete
* deterministic
* testable
* evolvable
* boring (in the best way)

You’re done designing routing.

Everything after this is implementation detail.

---

If you want next (optional, future):

* metrics per ReleasePlug
* automatic expiry of release plugs
* FABL contract validation
* CI checks to prevent long-lived releases

But architecturally — **this is finished**.
