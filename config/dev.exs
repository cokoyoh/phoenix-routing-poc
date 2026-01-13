import Config

config :spoti_web,
  env: :test,
  allowed_hosts: ~r/.*\.test\.spoti\.co\.ke/,
  webcore_url: "http://localhost.spoti.co.ke:3300",
  legacy_url: "http://localhost.spoti.co.ke:3301",
  fabl_base_url: "http://localhost:3210"

config :logger, level: :debug

config :phoenix, :stacktrace_depth, 20

config :spoti_web, Spoti.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  server: true,
  debug_errors: true,
  code_reloader: true

config :logger, :default_formatter,
  format: "$time [$level] $message $metadata\n",
  metadata: [:request_id, :url, :query, :method, :body, :data, :status, :env, :target, :reason, :timeout, :kind, :error, :stacktrace]
